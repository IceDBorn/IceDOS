local plugins = {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings("nvimtree")
    end,
    config = function(_)
      local nvimtree_side = "left"
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup({
        filters = {
          dotfiles = false,
          exclude = { vim.fn.stdpath("config") .. "/lua/custom" },
        },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        view = {
          adaptive_size = false,
          side = nvimtree_side,
          width = 30,
          preserve_window_proportions = true,
        },
        git = {
          enable = true,
          ignore = true,
        },
        filesystem_watchers = {
          enable = true,
        },
        actions = {
          open_file = {
            resize_window = true,
          },
          change_dir = {
            global = true,
          },
        },
        renderer = {
          root_folder_label = true,
          highlight_git = true,
          highlight_modified = "name",

          indent_markers = {
            enable = false,
          },

          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },

            glyphs = {
              default = "󰈚",
              symlink = "",
              folder = {
                default = "󰉋",
                empty = "",
                empty_open = "",
                open = "",
                symlink = "",
                symlink_open = "",
                arrow_open = "",
                arrow_closed = "",
              },
              git = {
                unstaged = "",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
      })
      vim.g.nvimtree_side = nvimtree_side
    end,
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        auto_session_allowed_dirs = { "~/git/*" },
        auto_session_suppress_dirs = { "~/*" },
        pre_save_cmds = { "tabdo NvimTreeClose" },
        post_save_cmds = { "tabdo NvimTreeOpen" },
        post_open_cmds = { "tabdo NvimTreeOpen" },
        post_restore_cmds = { "tabdo NvimTreeOpen", vim.cmd("silent! bufdo e") },
        cwd_change_handling = {
          restore_upcoming_session = true,
          pre_cwd_changed_hook = nil,
          post_cwd_changed_hook = nil,
        },
      })
    end,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
  },
  {
    "kdheepak/lazygit.nvim",
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
        "csharp-language-server",
        "eslint-lsp",
        "gersemi",
        "html-lsp",
        "jdtls",
        "neocmakelsp",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("custom.configs.null-ls")
      end,
    },
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
    end,
  },
}
return plugins
