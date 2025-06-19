return {
  "nvimtools/none-ls.nvim",
  config = function()
    require("null-ls")
    vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, {})
  end,
}
