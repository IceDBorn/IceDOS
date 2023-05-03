
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = {
	"bashls",
	"clangd",
	"csharp_ls",
	"dockerls",
	"eslint",
	"gdscript",
	"html",
	"jdtls",
	"jedi_language_server",
	"lua_ls",
	"marksman",
	"neocmake",
	"nil_ls",
	"rust_analyzer",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
	on_attach = on_attach,
	capabilities = capabilities,
  }
end
