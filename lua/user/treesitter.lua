-- nvim-treesitter `main` branch (required for Neovim 0.12+).
-- The old module system (require("nvim-treesitter.configs").setup{...}) no
-- longer exists: parsers are installed via install(), and highlighting/indent
-- are enabled per buffer through Neovim's built-in treesitter.
local status_ok, ts = pcall(require, "nvim-treesitter")
if not status_ok then
  vim.notify("nvim-treesitter not found")
  return
end

-- Parsers to keep installed. `markdown_inline` is needed for fenced code
-- blocks; `vimdoc`/`query` are handy for help files and query editing.
local ensure = {
  "lua", "python", "javascript", "typescript", "tsx",
  "json", "yaml", "markdown", "markdown_inline",
  "bash", "vim", "vimdoc", "query",
}

-- Defaults are fine; call setup() only to be explicit about the install dir.
ts.setup {}

-- Install any missing parsers (async; a no-op if already present).
pcall(ts.install, ensure)

-- Don't enable treesitter for very large files.
local max_filesize = 100 * 1024 -- 100 KB

-- Indentation is experimental on the main branch; disabled for yaml, matching
-- the previous config.
local no_indent = { yaml = true }

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
  callback = function(args)
    local buf = args.buf

    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return
    end

    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if not lang then
      return
    end

    -- Only start if a parser is actually available for this language.
    if not pcall(vim.treesitter.start, buf, lang) then
      return
    end

    if not no_indent[vim.bo[buf].filetype] then
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
