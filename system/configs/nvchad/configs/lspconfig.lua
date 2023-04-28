
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = {
  "bashls",
  "clangd",
  "cmake",
  "csharp_ls",
  "cssls",
  "dockerls",
  "gdscript",
  "html",
  "java_language_server",
  "jsonls",
  "lua_ls",
  "marksman",
  "nil_ls",
  "pylsp",
  "rust_analyzer",
  "tsserver",
  "vimls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
	on_attach = on_attach,
	capabilities = capabilities,
  }
end
