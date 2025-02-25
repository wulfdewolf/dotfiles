return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ltex",
					"pylsp",
					"ruff",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.ruff.setup({})

			vim.keymap.set("n", "<leader>d", ":vsplit | lua vim.lsp.buf.definition()<CR>")

			-- Disable overlap between Ruff and Pylsp
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client == nil then
						return
					end
					if client.name == "ruff" then
						-- Disable hover in favor of Pyright
						client.server_capabilities.hoverProvider = false
					end
				end,
				desc = "LSP: Disable hover capability from Ruff",
			})

			lspconfig.pylsp.setup({})
		end,
	},
}
