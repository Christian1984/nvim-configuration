local M = {}

-- Language of the explanation. Override in init.lua before this module is required.
vim.g.claude_explain_language = vim.g.claude_explain_language or "English"

local function git(args)
  local result = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait()
  return result.code == 0 and vim.trim(result.stdout) or nil
end

-- One Claude session per ticket, named "<ticket>: code explainer". The ticket comes from the
-- branch name (EM-1234); without one, the repository name stands in. The session id is kept
-- under the nvim state dir so later calls can resume it.
local function session_file()
  local branch = git({ "branch", "--show-current" }) or ""
  local repo = vim.fs.basename(git({ "rev-parse", "--show-toplevel" }) or vim.fn.getcwd())
  local ticket = branch:match("%u+%-%d+") or repo
  local dir = vim.fn.stdpath("state") .. "/claude-sessions"
  vim.fn.mkdir(dir, "p")
  return dir .. "/" .. ticket, ticket
end

local function ask(prompt, on_done)
  local file, ticket = session_file()
  local existing = vim.fn.filereadable(file) == 1 and vim.trim(table.concat(vim.fn.readfile(file), "")) or nil

  local function start_fresh()
    local id = vim.trim(vim.fn.system("uuidgen")):lower()
    vim.fn.writefile({ id }, file)
    vim.system({ "claude", "-p", "--session-id", id, "--name", ticket .. ": code explainer", prompt },
      { text = true }, on_done)
  end

  if not existing then return start_fresh() end
  vim.system({ "claude", "-p", "--resume", existing, prompt }, { text = true }, function(result)
    -- a stale id (session pruned or started in another directory) cannot be resumed: start over
    if result.code ~= 0 then
      vim.fn.delete(file)
      return start_fresh()
    end
    on_done(result)
  end)
end

-- The diff the current buffer is part of: inside Diffview the view's own revision range for the
-- current file, elsewhere the working tree against HEAD. Returns the diff and a label for it.
local function current_diff()
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
    return git(args) or "", view.rev_arg or (view.left:object_name(8) .. ".." .. view.right:object_name(8))
  end
  local path = vim.fn.expand("%:p")
  return git({ "diff", "HEAD", "--", path }) or "", "working tree vs HEAD"
end

function M.build_prompt(first, last)
  local code = table.concat(vim.api.nvim_buf_get_lines(0, first - 1, last, false), "\n")
  local diff, range = current_diff()
  local file = vim.fn.expand("%:t")
  local parts = {
    string.format("Explain the selected section of %s. Cover what the code does and, using the diff, why it "
      .. "changed: what is new or removed, and what purpose a newly introduced helper, parameter or type serves. "
      .. "Be concise, plain prose. Answer in %s.", file, vim.g.claude_explain_language),
    "Selected lines:\n```\n" .. code .. "\n```",
  }
  if diff ~= "" then
    table.insert(parts, string.format("Diff of %s (%s):\n```diff\n%s\n```", file, range, diff))
  else
    table.insert(parts, "There is no diff for this file; explain the code on its own.")
  end
  return table.concat(parts, "\n\n")
end

function M.explain_selection()
  local prompt = M.build_prompt(vim.fn.line("'<"), vim.fn.line("'>"))

  vim.cmd("botright vnew")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype, vim.bo[buf].bufhidden, vim.bo[buf].filetype = "nofile", "wipe", "markdown"
  vim.wo.wrap = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Asking Claude…" })

  ask(prompt, vim.schedule_wrap(function(result)
    local text = result.stdout ~= "" and result.stdout or result.stderr
    if not vim.api.nvim_buf_is_valid(buf) then return end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n"))
  end))
end

-- ":<C-u>" leaves visual mode first, which is what sets the '< and '> marks
vim.keymap.set("x", "<leader>e", ":<C-u>lua require('user.claude').explain_selection()<CR>",
  { silent = true, desc = "Explain selection with Claude" })

return M
