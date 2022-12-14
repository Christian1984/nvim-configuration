local colorscheme = "tokyonight"

vim.g.tokyonight_style = "night"
-- vim.g.tokyonight_italic_comments = true
-- vim.g.tokyonight_italic_functions = true

-- vim.g.lightline = {
--   colorscheme = "tokyonight",
-- }

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
