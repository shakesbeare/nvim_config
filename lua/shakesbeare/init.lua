require("shakesbeare.set")

vim.filetype.add({ extension = { p8 = "pico8" } })

-- vim.api.nvim_create_autocmd("TermOpen", {
-- 	group = vim.api.nvim_create_augroup("term_insert_mode", {}),
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.cmd("startinsert")
-- 	end,
-- })

vim.api.nvim_create_autocmd({ "UiEnter" }, {
	group = vim.api.nvim_create_augroup("toggle_no_nock_pain", {}),
	pattern = "*",
	callback = function() 
		require('no-neck-pain').enable()
	end
})

vim.api.nvim_create_autocmd({ "WinEnter", "WinResized" }, {
	group = vim.api.nvim_create_augroup("set_tabline_offset", {}),
	pattern = "*",
	callback = function()
		local wins = vim.api.nvim_list_wins()
		for _, win in ipairs(wins) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].filetype == "NvimTree" then
				vim.g.tabline_tree_offset = vim.api.nvim_win_get_width(win)
			end
		end
	end
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("yank_highlight", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- plugins which require no setup go here
-- or general setup which should take place
-- after plugins are loaded

local get_buf_as_str = function(bufnr)
	local text = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	return table.concat(text, "\n")
end

local uses_tabs = function(bufnr)
	local text = get_buf_as_str(bufnr)
	local spaces_substring = string.rep(" ", vim.o.tabstop)
	local _, t_count = string.gsub(text, "\t", "")
	local _, s_count = string.gsub(text, spaces_substring, "")

	if t_count > s_count then
		return true
	else
		return false
	end
end

-- set expandtab based on whether the file uses tabs or not
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("user_defined", {}),
	callback = function(ev)
		if uses_tabs(ev.buf) then
			vim.o.expandtab = false
		else
			vim.o.expandtab = true
		end
	end,
})

vim.api.nvim_create_autocmd("Filetype", {
	group = vim.api.nvim_create_augroup("gdcomment", {}),
	pattern = "gdscript",
	callback = function(ev)
		vim.api.nvim_buf_set_option(ev.buf, "commentstring", "# %s")
	end,
})
-- plugins which require no setup go here
-- or general setup which should take place
-- after plugins are loaded

local get_buf_as_str = function(bufnr)
	local text = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	return table.concat(text, "\n")
end

local uses_tabs = function(bufnr)
	local text = get_buf_as_str(bufnr)
	local spaces_substring = string.rep(" ", vim.o.tabstop)
	local _, t_count = string.gsub(text, "\t", "")
	local _, s_count = string.gsub(text, spaces_substring, "")

	if t_count > s_count then
		return true
	else
		return false
	end
end

-- set expandtab based on whether the file uses tabs or not
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("user_defined", {}),
	callback = function(ev)
		if uses_tabs(ev.buf) then
			vim.o.expandtab = false
		else
			vim.o.expandtab = true
		end
	end,
})

vim.filetype.add {
    pattern = {
        ['.*%.ipynb.*'] = 'python',
        -- uses lua pattern matching
        -- rathen than naive matching
    },
}
