-- Skip deprecated ts_context_commentstring module
vim.g.skip_ts_context_commentstring_module = true

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
    enable = true,
    disable = function(lang, buf)
      -- Disable for very large files
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true, disable = { "yaml" } },
  -- Disable rainbow - it can cause issues with newer treesitter
  -- rainbow = {
  --   enable = true,
  --   extended_mode = true,
  --   max_file_lines = nil,
  -- }
}

local status_ok, install = pcall(require, "nvim-treesitter.install")
if not status_ok then
    vim.notify("nvim-treesitter.install not found")
    return
end

install.compilers = {
    "clang"
}
