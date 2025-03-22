return {
	"neovim/nvim-lspconfig",
	lazy = true,
	dependencies = {
		"hrsh7th/nvim-cmp",
		"j-hui/fidget.nvim",
		"folke/neodev.nvim",
	},
	config = function()
		require("neodev").setup()
		-- Set up lspconfig.
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- vim.api.nvim_create_autocmd("LspAttach", {
		-- 	group = vim.api.nvim_create_augroup("user_defined_lsp", {}),
		-- 	callback = function(args)
		-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- 		if client.server_capabilities.inlayHintProvider then
		-- 			vim.lsp.inlay_hint.enable(args.buf, true)
		-- 		end
		-- 	end,
		-- })

		-- place servers here when they are not handled by Mason
		require("lspconfig").gdscript.setup({
			capabilities = capabilities,
			cmd = { "nc", "localhost", "6005" },
		})
		
		require('lspconfig').nixd.setup({
			cmd = { 'nixd' },
			settings = {
				nixd = {
					nixpkgs = {
						expr = "import <nixpkgs> { }",
					},
					formatting = {
						command = { "alejandra" },
					},
					options = {
						nixos = {
							expr = '(builtins.getFlake "~/.dotfiles/flake.nix").nixosConfigurations.nixos-dt.options',
						},
						-- home_manager = {
						-- 	expr = '(builtins.getFlake "~/.dotfiles/flake.nix").homeConfigurations.nixos-dt.options',
						-- },
					},

				},
			},
		})

		require('lspconfig')['hls'].setup {
			filetypes = { 'haskell', 'lhaskell', 'cabal' },
		}

		require('lspconfig').clangd.setup {
			capabilities = capabilities,
		}

		require("lspconfig").rust_analyzer.setup({
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						allFeatures = true,
						overrideCommand = {
							"cargo",
							"clippy",
							"--workspace",
							"--message-format=json",
							"--all-targets",
							"--all-features",
							"--",
							"-A",
							"clippy::needless_return",
						},
					},
					completion = {
						postfix = {
							enable = false,
						},
					},
					inlayHints = {
						closingBraceHints = {
							enable = true,
							minLines = 0, -- doesn't seem to work when changed, 25 is the default
						},
						typeHints = {
							enable = true,
						},
						parameterHints = {
							enable = false,
						},
						chainingHints = {
							enable = false,
						},
					},
				},
			},
		})
	end,
}
