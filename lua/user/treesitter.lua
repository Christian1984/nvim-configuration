local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    vim.notify("nvim-treesitter.configs not found")
    return
end

configs.setup {
  ensure_installed = { "lua", "python", "javascript", "typescript", "json", "yaml", "markdown", "bash", "vim" },
  sync_install = false,
  auto_install = true, -- Auto-install parsers when opening files
  ignore_install = { "ipkg" }, -- Ignore broken parsers
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "html" }, -- list of language that will be disabled
    -- additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

local status_ok, install = pcall(require, "nvim-treesitter.install")
if not status_ok then
    vim.notify("nvim-treesitter.install not found")
    return
end

install.compilers = {
    "clang"
}
