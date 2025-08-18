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
                    "pyright",
                    "ruff",
                    "html",
                    "matlab_ls",
                    "marksman",
                    "tinymist"
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
            lspconfig.ruff.setup({})
            lspconfig.marksman.setup({})
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
            vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, {})

            -- Disable overlap between Ruff and Pyright
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
            require('lspconfig').pyright.setup {
                on_attach = function(client, bufnr)
                    client.server_capabilities.diagnosticProvider = nil
                end,
                settings = {
                    pyright = {
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            ignore = { '*' },
                            typeCheckingMode = "off",
                        },
                    },
                },
            }
            vim.lsp.enable('pyright')
        end,
    },
}
