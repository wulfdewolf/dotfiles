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
          "html",
          "marksman",
          "matlab_ls"
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
      lspconfig.html.setup({
        filetypes = { "html", "liquid" }
      })
      lspconfig.matlab_ls.setup({
        settings = {
          MATLAB = {
            indexWorkspace = true,
            matlabConnectionTiming = "onStart",
            installPath = "/usr/local/MATLAB/R2024b/",
            telemetry = true,
          },
        },
        single_file_support = true
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover)
      vim.keymap.set("n", "<leader>d", ":vsplit | lua vim.lsp.buf.definition()<CR>")
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

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
