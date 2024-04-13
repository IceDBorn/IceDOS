local null_ls = require("null-ls")

local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local sources = {
  diagnostics.phpstan,
  formatting.beautysh,
  formatting.black,
  formatting.clang_format,
  formatting.gdformat,
  formatting.nixfmt,
  formatting.pint,
  formatting.prettier,
  formatting.rustfmt,
  formatting.stylua,
}

null_ls.setup({
  sources = sources,
})
