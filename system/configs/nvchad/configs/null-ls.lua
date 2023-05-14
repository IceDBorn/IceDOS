local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
	formatting.beautysh,
	formatting.black,
	formatting.clang_format,
	formatting.gdformat,
	formatting.gersemi,
	formatting.nixfmt,
	formatting.prettier,
	formatting.rustfmt,
	formatting.stylua,
}

null_ls.setup {
   sources = sources,
}

