-- Setup mason first
local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

mason.setup({
	ui = {
		border = "rounded",
	},
})

-- mason-lspconfig v2 removed setup_handlers(). Installed servers are now
-- enabled automatically via vim.lsp.enable() (automatic_enable = true), and
-- per-server settings are supplied through Neovim's native vim.lsp.config().
local status_ok_ml, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_ml then
	return
end

local handlers = require("user.lsp.handlers")

-- Defaults applied to every server (merged under each server's own config).
vim.lsp.config("*", {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
})

-- Per-server overrides, merged on top of nvim-lspconfig's base lsp/<name>.lua.
vim.lsp.config("lua_ls", require("user.lsp.settings.lua_ls"))
vim.lsp.config("jsonls", require("user.lsp.settings.jsonls"))
vim.lsp.config("pyright", require("user.lsp.settings.pyright"))

mason_lspconfig.setup({
	ensure_installed = { "lua_ls", "jsonls", "pyright" },
	automatic_enable = true,
})
