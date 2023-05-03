
local plugins = {
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup {
				auto_session_allowed_dirs = { "~/dev/*", },
				auto_session_suppress_dirs = { "~/*", },
				auto_session_root_dir = ".sessions/"
			}
		end,
	},
	{
		"nvim-lua/plenary.nvim",
		lazy = false,
	},
	{
		"timuntersberger/neogit",
		lazy = false,
	},
	{
		"sqve/sort.nvim",
		lazy = false,
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
	{
		"nvim-pack/nvim-spectre",
		lazy = false,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"c_sharp",
				"cmake",
				"cpp",
				"css",
				"diff",
				"dockerfile",
				"gdscript",
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"html",
				"java",
				"javascript",
				"json",
				"lua",
				"markdown",
				"nix",
				"python",
				"rust",
				"tsx",
				"typescript",
				"vim",
			},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"bash-language-server",
				"beautysh",
				"black",
				"clang-format",
				"clangd",
				"csharp-language-server",
				"dockerfile-language-server",
				"eslint-lsp",
				"gersemi",
				"html-lsp",
				"jdtls",
				"jedi-language-server",
				"lua-language-server",
				"marksman",
				"neocmakelsp",
				"nil",
				"prettier",
				"rust-analyzer",
				"rustfmt",
				"stylua",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
			require "custom.configs.null-ls"
			end,
		},
		config = function()
			require "plugins.configs.lspconfig"
			require "custom.configs.lspconfig"
		end,
	},
}
return plugins
