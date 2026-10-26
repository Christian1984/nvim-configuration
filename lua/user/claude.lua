local M = {}

-- Language of the explanation and the model to use (nil = Claude Code's configured default).
-- Override both in init.lua before this module is required.
vim.g.claude_explain_language = vim.g.claude_explain_language or "English"

local function git(args)
  local result = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait()
  return result.code == 0 and vim.trim(result.stdout) or nil
end

-- The ticket comes from the branch name (EM-1234); without one, the repository name stands in.
local function ticket_and_root()
  local root = git({ "rev-parse", "--show-toplevel" }) or vim.fn.getcwd()
  local branch = git({ "branch", "--show-current" }) or ""
  return branch:match("%u+%-%d+") or vim.fs.basename(root), root
end

-- The branch a feature branch is compared against: the remote's default branch, else main/master.
function M.base_branch()
  local head = git({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })
  if head then return (head:gsub("^origin/", "")) end
  for _, name in ipairs({ "main", "master" }) do
    if git({ "rev-parse", "--verify", "--quiet", "refs/heads/" .. name }) then return name end
  end
  return nil
end

-- One Claude session per ticket, named "<ticket>: code explainer". The session id is kept under
-- the nvim state dir so later calls can resume it.
local function ask(prompt, on_done)
  local ticket = ticket_and_root()
  local dir = vim.fn.stdpath("state") .. "/claude-sessions"
  vim.fn.mkdir(dir, "p")
  local file = dir .. "/" .. ticket
  local existing = vim.fn.filereadable(file) == 1 and vim.trim(table.concat(vim.fn.readfile(file), "")) or nil

  local function claude(args)
    local cmd = { "claude", "-p" }
    if vim.g.claude_explain_model then vim.list_extend(cmd, { "--model", vim.g.claude_explain_model }) end
    return vim.list_extend(vim.list_extend(cmd, args), { prompt })
  end

  local function start_fresh()
    local id = vim.trim(vim.fn.system("uuidgen")):lower()
    vim.fn.writefile({ id }, file)
    vim.system(claude({ "--session-id", id, "--name", ticket .. ": code explainer" }), { text = true }, on_done)
  end

  if not existing then return start_fresh() end
  vim.system(claude({ "--resume", existing }), { text = true }, vim.schedule_wrap(function(result)
    -- only a stale id (session pruned or started elsewhere) justifies a new session; any other
    -- failure, such as being logged out, keeps the id so the dialog continues once it is fixed
    if result.code ~= 0 and (result.stderr .. result.stdout):find("No conversation found", 1, true) then
      vim.fn.delete(file)
      return start_fresh()
    end
    on_done(result)
  end))
end

-- Where the current buffer sits in the repository and which diff it is part of: inside Diffview
-- the view's own revision range for the current file, elsewhere the branch against its base branch.
local function current_location()
  local ok, lib = pcall(require, "diffview.lib")
  local view = ok and lib.get_current_view() or nil
  if view and view.cur_entry and view.left then
    local RevType = require("diffview.vcs.rev").RevType
    local path = view.cur_entry.path
    local args = { "diff", view.left:object_name() }
    if view.right.type == RevType.STAGE then
      table.insert(args, "--cached")
    elseif view.right.type ~= RevType.LOCAL then
      table.insert(args, view.right:object_name())
    end
    vim.list_extend(args, { "--", path })
    local range = view.rev_arg or (view.left:object_name(8) .. ".." .. view.right:object_name(8))
    return path, git(args) or "", range
  end
  local _, root = ticket_and_root()
  local path = vim.fn.expand("%:p")
  local relative = vim.startswith(path, root .. "/") and path:sub(#root + 2) or path
  -- the branch's whole change so far, committed or not; on the base branch itself that is the working tree
  local base_branch = M.base_branch()
  local base = base_branch and git({ "merge-base", base_branch, "HEAD" })
  if base then
    return relative, git({ "diff", base, "--", path }) or "", base_branch .. "...working tree"
  end
  return relative, git({ "diff", "HEAD", "--", path }) or "", "working tree vs HEAD"
end
M.current_location = current_location

-- The dialog lives in .scratch/<ticket>/code-explain.md (lowercase slug, like the team's PRD
-- folders) and is shown in one window on the right.
local function dialog_buffer()
  local ticket, root = ticket_and_root()
  local path = string.format("%s/.scratch/%s/code-explain.md", root, ticket:lower())
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local buf = vim.fn.bufnr(path)
  local win = buf ~= -1 and vim.fn.bufwinid(buf) or -1
  if win ~= -1 then
    vim.api.nvim_set_current_win(win)
  else
    vim.cmd("botright vsplit " .. vim.fn.fnameescape(path))
    vim.wo.wrap = true
  end
  buf = vim.api.nvim_get_current_buf()
  vim.keymap.set("n", "<leader>a", M.ask_followup, { buffer = buf, desc = "Follow-up question to Claude" })
  return buf
end

local namespace = vim.api.nvim_create_namespace("claude-explain")

-- Appends a heading and a placeholder, asks Claude, then swaps the placeholder for the answer and
-- writes the file. On an error the pending block is removed again: the file only ever holds answers.
local function converse(heading, prompt)
  local buf = dialog_buffer()
  local last = vim.api.nvim_buf_line_count(buf)
  local empty = last == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
  local start = empty and 0 or last
  vim.api.nvim_buf_set_lines(buf, start, -1, false, { heading, "", "_Claude antwortet…_", "" })
  -- extmarks follow the block even if the user edits above it while waiting
  local from = vim.api.nvim_buf_set_extmark(buf, namespace, start, 0, {})
  local to = vim.api.nvim_buf_set_extmark(buf, namespace, start + 3, 0, {})
  vim.api.nvim_buf_call(buf, function() vim.cmd("normal! G") end)

  ask(prompt, vim.schedule_wrap(function(result)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    local first = vim.api.nvim_buf_get_extmark_by_id(buf, namespace, from, {})[1]
    local after = vim.api.nvim_buf_get_extmark_by_id(buf, namespace, to, {})[1] + 1
    vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)
    local text = vim.trim(result.stdout ~= "" and result.stdout or result.stderr)
    if result.code ~= 0 then
      vim.api.nvim_buf_set_lines(buf, first, after, false, {})
      local on_disk = vim.fn.filereadable(vim.api.nvim_buf_get_name(buf)) == 1
        and vim.fn.readfile(vim.api.nvim_buf_get_name(buf)) or {}
      if vim.deep_equal(vim.api.nvim_buf_get_lines(buf, 0, -1, false), on_disk) then vim.bo[buf].modified = false end
      vim.notify(string.format("Claude (exit %d): %s", result.code, text ~= "" and text or "keine Ausgabe"),
        vim.log.levels.ERROR)
      return
    end
    vim.api.nvim_buf_set_lines(buf, first + 2, first + 3, false, vim.split(text, "\n"))
    vim.api.nvim_buf_call(buf, function() vim.cmd("silent write") end)
  end))
end

function M.explain_selection()
  local first, last = vim.fn.line("'<"), vim.fn.line("'>")
  local code = table.concat(vim.api.nvim_buf_get_lines(0, first - 1, last, false), "\n")
  local path, diff, range = current_location()
  local location = string.format("%s:%d-%d", path, first, last)
  local parts = {
    string.format("Explain the selected section of %s in exactly two sections, each under a level-3 markdown "
      .. "heading. First heading: 'What it does', covering what the code does. Second heading: 'What changed and "
      .. "why', using the diff: what is new or removed, and what purpose a newly introduced helper, parameter or "
      .. "type serves; if the file has no diff, say so in one sentence. Translate both headings into the answer "
      .. "language. Be concise, plain prose. Answer in %s.", location, vim.g.claude_explain_language),
    "Selected lines:\n```\n" .. code .. "\n```",
    diff ~= "" and string.format("Diff of %s (%s):\n```diff\n%s\n```", path, range, diff)
      or "There is no diff for this file; explain the code on its own.",
  }
  converse(string.format("## `%s` (%s)", location, os.date("%Y-%m-%d %H:%M")), table.concat(parts, "\n\n"))
end

function M.ask_followup(question)
  if type(question) ~= "string" or question == "" then
    return vim.ui.input({ prompt = "Frage an Claude: " }, function(input)
      if input and input ~= "" then M.ask_followup(input) end
    end)
  end
  converse("**Frage:** " .. question, question .. "\n\nAnswer in " .. vim.g.claude_explain_language .. ", no heading.")
end

-- ":<C-u>" leaves visual mode first, which is what sets the '< and '> marks
vim.keymap.set("x", "<leader>e", ":<C-u>lua require('user.claude').explain_selection()<CR>",
  { silent = true, desc = "Explain selection with Claude" })
vim.api.nvim_create_user_command("ClaudeAsk", function(opts) M.ask_followup(opts.args) end,
  { nargs = "*", desc = "Follow-up question in the ticket's code-explain dialog" })

return M
