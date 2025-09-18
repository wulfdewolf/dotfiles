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
                    "basedpyright",
                    "html",
                    "matlab_ls",
                    "marksman",
                    "tinymist",
                    "ruff"
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.basedpyright.setup({
                capabilities = capabilities,
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "basic",
                        },
                    },
                }
            })
            lspconfig.marksman.setup({})
            lspconfig.ruff.setup({})
            lspconfig.matlab_ls.setup({})
            lspconfig.html.setup({
                filetypes = { "html", "liquid" }
            })
            lspconfig.tinymist.setup {
                settings = {
                    formatterMode = "typstyle",
                    semanticTokens = "disable",
                    formatterProseWrap = true,
                    formatterPrintWidth = 88
                }
            }
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client == nil then
                        return
                    end
                    if client.name == 'ruff' then
                        -- Disable hover in favor of Pyright
                        client.server_capabilities.hoverProvider = false
                    end
                end,
                desc = 'LSP: Disable hover capability from Ruff',
            })
            vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, {})
        end,
    },
}
