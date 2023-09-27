-- :help options
local tabwidth = 4

local options = {
    clipboard = "unnamedplus", -- allows neovim to access the system clipboard
}

for k,v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.shortmess:append "c"

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

vim.api.nvim_exec("language en_US.UTF-8", true) -- extend with UTF-8 to properly copy umlauts to system clipboard
