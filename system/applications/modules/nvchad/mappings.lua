local M = {}

M.abc = {
  v = {
    ["<S-Tab>"] = { "<gv", "Unindent" },
    ["<Tab>"] = { ">gv", "Indent" },
    ["<leader>s"] = { "<ESC> <cmd> Sort <CR>", "Sort selection" },
  },
  n = {
    ["<leader>ff"] = { "<cmd> Telescope live_grep <CR>", "Find" },
    ["<leader>fr"] = { "<cmd> Spectre <CR>", "Find and Replace" },
    ["<leader>gg"] = { "<cmd> LazyGit <CR>", "Source control" },
    ["<leader>ma"] = { "ggVG", "Mark all" },
    ["C-h"] = { "<cmd> TmuxNavigateLeft <CR>", "Focus left" },
    ["C-j"] = { "<cmd> TmuxNavigateDown <CR>", "Focus down" },
    ["C-k"] = { "<cmd> TmuxNavigateUp <CR>", "Focus up" },
    ["C-l"] = { "<cmd> TmuxNavigateRight <CR>", "Focus right" },
  },
  i = {
    ["jk"] = { "<ESC>", "Escape insert mode", opts = { nowait = true } },
  },
}

return M
