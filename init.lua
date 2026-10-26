-- pcall(require, "impatient")

-- Disable the python3 remote-plugin provider. Not used here, and on Neovim
-- 0.12 the bundled python ftplugin errors when g:loaded_python3_provider is
-- unset. (Treesitter/LSP for Python are unaffected by this.)
vim.g.loaded_python3_provider = 0

if vim.g.vscode then
    -- VSCode Neovim integration: don't auto-load packer start plugins /
    -- packer_compiled.lua; VSCode owns UI, LSP, git, commenting, etc.
    vim.opt.loadplugins = false

    require "user.vscode.options"
    require "user.vscode.keymaps"
else
    -- Regular Neovim
    require "user.packer"
    require "user.plugins"
    require "user.keymaps"
    require "user.colorscheme"
    require "user.cmp"
    require "user.lsp"
    require "user.telescope"
    require "user.treesitter"
    require "user.lualine"
    require "user.bufferline"
    require "user.scrollbar"
    require "user.autopairs"
    require "user.comment"
    require "user.gitsigns"
    require "user.nvim-tree"
    require "user.indent-blankline"
    require "user.diffview"
    vim.g.claude_explain_language = "English" -- language of <leader>e explanations
    require "user.claude"
end


