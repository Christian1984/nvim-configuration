local opts = { noremap = false, silent = false }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

-- Leader
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ignore
keymap("", "<C-a>", "<Nop>", opts)
keymap("", "<C-f>", "<Nop>", opts)
keymap("", "<C-c>", "<Nop>", opts)
keymap("", "<C-x>", "<Nop>", opts)
keymap("", "<C-v>", "<Nop>", opts)

-- Normal Mode
-- Navigate Tabs with, um, Tab
keymap("n", "<Tab>", ":Tabnext<CR>", opts)
keymap("n", "<S-Tab>", ":Tabprev<CR>", opts)

-- Better Window Navigation
-- keymap("n", "<C-p>", ":call VSCodeCall('workbench.action.quickOpen')<CR>", opts)
keymap("n", "<leader>h", ":call VSCodeCall('workbench.action.navigateLeft')<CR>", opts)
keymap("n", "<leader>l", ":call VSCodeCall('workbench.action.navigateRight')<CR>", opts)

-- toogle commentes
keymap("n", "gcc", ":call VSCodeCall('editor.action.commentLine')<CR>", opts)

-- rename, goto definition
keymap("n", "gn", ":call VSCodeCall('editor.action.rename')<CR>", opts)
keymap("n", "gd", ":call VSCodeCall('editor.action.revealDefinition')<CR>", opts)
keymap("n", "gh", ":call VSCodeCall('editor.action.showHover')<CR>", opts)
keymap("n", "gl", ":call VSCodeCall('editor.action.showHover')<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- toogle commentes
keymap("v", "gc", ":call VSCodeCall('editor.action.commentLine')<CR>", opts)