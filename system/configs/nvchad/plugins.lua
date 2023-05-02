
local plugins = {
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
			  "clangd",
			  "cmake-language-server",
			  "css-lsp",
			  "dockerfile-language-server",
			  "html-lsp",
			  "json-lsp",
			  "luau-lsp",
			  "marksman",
			  "nil",
			  "python-lsp-server",
			  "rust-analyzer",
			  "typescript-language-server",
			  "vim-language-server",
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

