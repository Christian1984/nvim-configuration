local opts = { noremap = false, silent = false }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

-- Leader
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal Mode
-- Better Window Navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<A-Up>", ":resize +2<CR>", opts)
keymap("n", "<A-Down>", ":resize -2<CR>", opts)
keymap("n", "<A-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<A-Right>", ":vertical resize +2<CR>", opts)

-- nvim-tree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Navigate buffers
keymap("n", "<leader>l", ":bnext<CR>", opts)     -- changed to <leader>* to keept default <S-*> behaviour
keymap("n", "<leader>h", ":bprevious<CR>", opts) -- changed to <leader>* to keept default <S-*> behaviour

-- Toggle Wrapping
keymap("n", "<leader>w", ":set wrap!<CR>", opts) -- toggle linewrap
-- keymap("n", "<leader>w", ":set wrap! linebreak!<CR>", opts) -- toggle linewrap

-- Telescope
-- keymap("n", "<leader>f", "<cmd>Telescope git_files<cr>", opts)
-- keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<C-p>", "<cmd>Telescope find_files<cr>", opts)
-- keymap("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
-- keymap("n", "<c-t>", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<C-f>", "<cmd>Telescope live_grep<cr>", opts)

-- Select All
keymap("n", "<C-a>", "ggVG", opts)

-- Set Indent Depth
keymap("n", "<leader>i2", ":set shiftwidth=2<CR>:set tabstop=2<CR>", opts)
keymap("n", "<leader>i4", ":set shiftwidth=4<CR>:set tabstop=4<CR>", opts)

-- nohl
keymap("n", "<leader>s", ":nohl<CR>", opts)

-- close buffer
keymap("n", "<leader>x", ":bw<CR>", opts)

-- git
keymap("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", opts)

-- Insert --
-- Press jk fast to enter
-- keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
-- keymap("v", "<A-j>", ":m .+1<CR>==", opts)
-- keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
-- keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- keymap("n", "<leader>i", ":tabnew ~\\AppData\\Local\\nvim<CR>", opts)
-- keymap("n", "<leader>i", ":!wt.exe nvim.exe ~\\AppData\\Local\\nvim<CR>", opts)
