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
                    "html",
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
            lspconfig.ruff.setup({})
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
        end,
    },
}
