local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- unbind annoying stuff
vim.keymap.set("n", "Q", "<nop>", { noremap = true })

-- makes v-block mode a bit better
vim.keymap.set("i", "<C-c>", "<Esc>", { noremap = true, desc = "Allow <C-c> to act as <Esc> in visual mode" })

-- move selection up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })

-- Improved yank/delete/paste controls
vim.keymap.set("x", "<leader>p", '"_dP', { noremap = true, desc = "Paste over selection lossy" })
vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>d", '"_d', { noremap = true, desc = "Delete lossy" })
vim.keymap.set("v", "<leader>d", '"_d', { noremap = true, desc = "Delete lossy" })

-- Become a master of the universe
vim.keymap.set("n", "<C-p>", function()
	-- pcall to catch KeyboardInterrupt error
	pcall(function()
		local command = vim.fn.input("$❯ ")
		command = command:gsub(".", function(c)
			return "\\" .. c
		end)
		local full_command = ":15split +term\\ " .. command
		vim.cmd(full_command)
		-- go to the end of the output
		local cmd = vim.api.nvim_replace_termcodes("G", true, true, true)
		vim.api.nvim_feedkeys(cmd, "n", true)
	end)
end, { silent = true, noremap = true, desc = "Execute Terminal Command" })

local function check_build_file()
	if not vim.uv.fs_stat('.buildfile') then
		local fidget = require('fidget')
		fidget.notify("Creating template .buildfile, save and re-run command")

		local template_location = vim.uv.os_homedir() .. "/.dotfiles/nvim_config/lua/.buildfile"
		local template_bufnr = vim.fn.bufadd(template_location)
		vim.fn.bufload(template_bufnr)
		local template = vim.api.nvim_buf_get_lines(template_bufnr, 0, -1, false)
		
		local new_bufnr = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_buf_set_name(new_bufnr, '.buildfile')
		vim.api.nvim_buf_set_lines(new_bufnr, 0, 0, false, template)
		vim.api.nvim_win_set_buf(0, new_bufnr)
		vim.bo[new_bufnr].filetype = "lua"
		return false
	end
	return true
end
-- Run build configuration in .buildfile in the workspace root
-- .buildfile is a lua file which returns a table in this format
-- return {
--     build = "echo Hello, Build!",
--     run = "echo Hello, Run!",
-- }
vim.keymap.set("n", "<C-b>", function()
	local fidget = require('fidget')
	if not check_build_file() then 
		return
	end

	local result = dofile('.buildfile')
	local cmd = {}
	for w in result.build:gmatch("%S+") do table.insert(cmd, w) end

	local buffer = {}
	vim.system(cmd, { text = true, stdout = function(err, data) 
		if err then
			fidget.notify(err)
		elseif data then
			fidget.notify(data)
		end
	end }, function(obj)
			fidget.notify("Build completed")
	end)
end, { silent = true, noremap = true, desc = "Find and execute a build configuration in the .buildfile in the workspace root"})

-- Run run configuration in .buildfile in the workspace root
-- .buildfile is a lua file which returns a table in this format
-- return {
--     build = "echo Hello, Build!",
--     run = "echo Hello, Run!",
-- }
vim.keymap.set("n", "<F5>", function()
	local fidget = require('fidget')
	if not check_build_file() then 
		return
	end

	local result = dofile('.buildfile')
	local cmd = {}
	for w in result.run:gmatch("%S+") do table.insert(cmd, w) end

	local buffer = {}
	vim.system(cmd, { text = true, stdout = function(err, data) 
		if err then
			fidget.notify(err)
		elseif data then
			fidget.notify(data)
		end
	end }, function(obj)
	end)
end, { silent = true, noremap = true, desc = "Find and execute a run configuration .buildfile in the workspace root"})

-- Become a master of the universe
vim.keymap.set("n", "<C-p>", function()
	-- pcall to catch KeyboardInterrupt error
	pcall(function()
		local command = vim.fn.input("$❯ ")
		command = command:gsub(".", function(c)
			return "\\" .. c
		end)
		local full_command = ":15split +term\\ " .. command
		vim.cmd(full_command)
		-- go to the end of the output
		local cmd = vim.api.nvim_replace_termcodes("G", true, true, true)
		vim.api.nvim_feedkeys(cmd, "n", true)
	end)
end, { silent = true, noremap = true, desc = "Execute Terminal Command" })

vim.keymap.set("n", "<A-t>", function()
	vim.cmd(":15split +term")
	local cmd = vim.api.nvim_replace_termcodes("i", true, true, true)
	vim.api.nvim_feedkeys(cmd, "n", true)
end, { noremap = true, silent = true, desc = "Open Terminal Split" })

-- Easier CONSTANT_CASE
vim.keymap.set("i", "<C-u>", function()
	local cmd = vim.api.nvim_replace_termcodes("<C-c>mabviw~`aa", true, true, true)
	vim.api.nvim_feedkeys(cmd, "n", true)
	vim.cmd([[delmarks a]])
end, { noremap = true, silent = true, desc = "Toggle case for previous word" })

-- Exit terminal mode with <Esc> or <C-[>
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- **********************************************************************
-- LSP Controls
vim.keymap.set("n", "gd", function()
	vim.lsp.buf.definition()
end, { noremap = true, silent = true, desc = "LSP: Goto Definition" })
vim.keymap.set("n", "<leader>li", function()
	vim.lsp.buf.implementation()
end, { noremap = true, silent = true, desc = "LSP: Implementation List" })
vim.keymap.set("n", "<leader>vd", function()
	vim.diagnostic.open_float()
end, { noremap = true, silent = true, desc = "LSP: Expand diagnostics" })
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover()
end, { noremap = true, silent = true, desc = "LSP: Show Hover" })
vim.keymap.set("n", "<leader>qf", function()
	require("conform").format({ lsp_fallback = "always" })
end, { noremap = true, silent = true, desc = "LSP: Format the current buffer" })

vim.keymap.set("n", "<leader>la", function()
	pcall(function()
		vim.lsp.buf.code_action()
	end)
end, { noremap = true, silent = true, desc = "LSP: Show code actions" })
vim.keymap.set("v", "<leader>la", function()
	vim.lsp.buf.code_action()
end, { noremap = true, silent = true, desc = "LSP: Show code actions" })
--vim.keymap.set('n', '<leader>ca', function() require('actions-preview').code_actions() end,
--{ noremap = true, silent = true })
vim.keymap.set("n", "<leader>r", function()
	vim.lsp.buf.rename()
end, { noremap = true, silent = true, desc = "LSP: Rename symbol" })
vim.keymap.set("i", "<C-k>", function()
	vim.lsp.buf.signature_help()
end, { silent = true })

-- **********************************************************************
--
-- **********************************************************************

-- accept copilot suggestion, if available
-- otherwise, expand luasnip snippet, if available
-- otherwise, expand cmp suggestion, if available
-- otherwise, insert tab/space
vim.keymap.set("i", "<Tab>", function()
	if require("luasnip").expand_or_jumpable() then
		require("luasnip").expand_or_jump()
	elseif has_words_before() then
		require("cmp").confirm({ select = true })
	else
		if vim.o.expandtab then
			vim.api.nvim_feedkeys(string.rep(" ", vim.o.tabstop), "i", true)
		else
			local key = vim.api.nvim_replace_termcodes("<C-v>009", true, false, true)
			vim.api.nvim_feedkeys(key, "i", true)
		end
	end
end, { noremap = true, silent = true, desc = "Expand snippet OR expand cmp OR insert tab/space" })
