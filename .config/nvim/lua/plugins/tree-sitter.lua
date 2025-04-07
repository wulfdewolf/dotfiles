return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "python", "lua", "latex", "html", "markdown", "matlab"},
      highlight = { enable = true },
    })
  end,
}
