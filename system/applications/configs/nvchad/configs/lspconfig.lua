local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local servers = {
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "eslint",
  "gdscript",
  "html",
  "intelephense",
  "jedi_language_server",
  "jsonls",
  "lua_ls",
  "marksman",
  "nil_ls",
  "rust_analyzer",
  "tailwindcss",
  "tsserver",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end
