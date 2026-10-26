local M = {}

function M.explain_selection()
  local first, last = vim.fn.line("'<"), vim.fn.line("'>")
  local code = table.concat(vim.api.nvim_buf_get_lines(0, first - 1, last, false), "\n")
  local prompt = string.format(
    "Explain what this section of %s does. Be concise, use plain prose.\n\n```\n%s\n```",
    vim.fn.expand("%:t"), code)

  vim.cmd("botright vnew")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype, vim.bo[buf].bufhidden, vim.bo[buf].filetype = "nofile", "wipe", "markdown"
  vim.wo.wrap = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Asking Claude…" })

  vim.system({ "claude", "-p", prompt }, { text = true }, vim.schedule_wrap(function(result)
    local text = result.stdout ~= "" and result.stdout or result.stderr
    if not vim.api.nvim_buf_is_valid(buf) then return end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n"))
  end))
end

-- ":<C-u>" leaves visual mode first, which is what sets the '< and '> marks
vim.keymap.set("x", "<leader>e", ":<C-u>lua require('user.claude').explain_selection()<CR>",
  { silent = true, desc = "Explain selection with Claude" })

return M
