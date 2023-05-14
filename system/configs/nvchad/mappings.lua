local M = {}

M.abc = {
	v = {
		[ "<Tab>" ] = { ">gv", "Indent" },
		[ "<S-Tab>" ] = { "<gv", "Unindent" },
		[ "<leader>s" ] = { "<ESC> <cmd> Sort <CR>", "Sort selection" },
	},
	n = {
		[ "<leader>fr" ] = { "<cmd> Spectre<CR>", "Find and Replace" },
		[ "<leader>ff" ] = { "<cmd> Telescope live_grep<CR>", "Find" },
		[ "<leader>gg" ] = { "<cmd> Neogit <CR>", "Source control" },
		[ "C-h" ] = { "<cmd> TmuxNavigateLeft <CR>", "Focus left" },
		[ "C-l" ] = { "<cmd> TmuxNavigateRight <CR>", "Focus right" },
		[ "C-j" ] = { "<cmd> TmuxNavigateDown <CR>", "Focus down" },
		[ "C-k" ] = { "<cmd> TmuxNavigateUp <CR>", "Focus up" },
	},
	i = {
		[ "jk" ] = { "<ESC>", "Escape insert mode" , opts = { nowait = true }},
	}
}

return M

