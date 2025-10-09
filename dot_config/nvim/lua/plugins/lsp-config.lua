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
                    "ruff",
                    "jedi_language_server",
                },
                automatic_installation = true,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Define a generic on_attach function for all servers
            local on_attach = function(_, bufnr)
                local bufmap = function(mode, lhs, rhs)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
                end
                bufmap("n", "<leader>ff", function() vim.lsp.buf.format({ async = true }) end)
                -- Add more LSP-related keymaps here if needed
            end

            -- Servers and their specific settings
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            workspace = { checkThirdParty = false },
                        },
                    },
                },
                ruff = {},
                jedi_language_server = {},
                html = {
                    filetypes = { "html", "liquid" },
                },
                tinymist = {
                    settings = {
                        formatterMode = "typstyle",
                        semanticTokens = "disable",
                        formatterProseWrap = true,
                        formatterPrintWidth = 88
                    }
                },
            }

            -- Setup each server with common capabilities and on_attach
            for name, opts in pairs(servers) do
                opts.capabilities = capabilities
                opts.on_attach = on_attach
                lspconfig[name].setup(opts)
            end
        end,
    },
}
