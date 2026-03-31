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

-- Setup mason-lspconfig
local status_ok_ml, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_ml then
	return
end

mason_lspconfig.setup({
	ensure_installed = { "lua_ls", "jsonls", "pyright" },
	automatic_installation = true,
})

-- Setup handlers for each server
local lspconfig = require("lspconfig")
local handlers = require("user.lsp.handlers")

mason_lspconfig.setup_handlers({
	-- Default handler for all servers
	function(server_name)
		local opts = {
			on_attach = handlers.on_attach,
			capabilities = handlers.capabilities,
		}
		lspconfig[server_name].setup(opts)
	end,
	
	-- Specific server configurations
	["lua_ls"] = function()
		local opts = require("user.lsp.settings.lua_ls")
		opts.on_attach = handlers.on_attach
		opts.capabilities = handlers.capabilities
		lspconfig.lua_ls.setup(opts)
	end,
	
	["jsonls"] = function()
		local opts = require("user.lsp.settings.jsonls")
		opts.on_attach = handlers.on_attach
		opts.capabilities = handlers.capabilities
		lspconfig.jsonls.setup(opts)
	end,
	
	["pyright"] = function()
		local opts = require("user.lsp.settings.pyright")
		opts.on_attach = handlers.on_attach
		opts.capabilities = handlers.capabilities
		lspconfig.pyright.setup(opts)
	end,
})

