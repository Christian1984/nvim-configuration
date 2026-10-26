-- nvim-web-devicons is installed as an opt plugin; load it so Diffview's file panel gets icons
pcall(vim.cmd.packadd, "nvim-web-devicons")
require("diffview").setup({ use_icons = pcall(require, "nvim-web-devicons") })
