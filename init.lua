-- pcall(require, "impatient")

require "user.packer"

if vim.g.vscode then
    require "user.vscode.options"
    require "user.vscode.keymaps"
else
    require "user.keymaps"
    require "user.packer"
    require "user.plugins"
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
end


