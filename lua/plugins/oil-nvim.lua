return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VimEnter",
	keys = {
		{
			"<leader>pv",
			function()
				if vim.bo.filetype == "oil" then
					require("oil").close()
				else
					require("oil").open()
				end
			end,
			{ silent = true, noremap = true },
		},
	},
	opts = {
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		columns = {
			"icon",
		},
		use_default_keymaps = false,
		keymaps = {
			["-"] = "actions.parent",
			["<CR>"] = "actions.select",
		},
		view_options = {
			show_hidden = true,
			sort = {
				{ "type", "asc" },
				{ "name", "asc" },
			},
			preview = {
				max_width = 0.4,
			},
		},
	},
}
