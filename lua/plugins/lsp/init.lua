local M = {}

table.insert(M, {
	{
		"hrsh7th/cmp-nvim-lsp-signature-help",
		event = "InsertEnter",
	},
})

local lspconfig = require("plugins.lsp.lspconfig")
local mason = require("plugins.lsp.mason")
local cmp = require("plugins.lsp.cmp")
local format = require("plugins.lsp.format")
-- local dap = require("plugins.lsp.dap")

table.insert(M, lspconfig)
table.insert(M, mason)
table.insert(M, cmp)
table.insert(M, format)
table.insert(M, dap)

return M
