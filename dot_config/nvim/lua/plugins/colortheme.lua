vim.pack.add({
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
})
vim.cmd.colorscheme("rose-pine")
--vim.cmd([colorscheme rosepine])
--return {
--    "rose-pine/neovim",
--    name = "rose-pine",
--    config = function()
--        require("rose-pine").setup({
--            styles = {
--                transparency = true,
--            },
--        })
--        vim.cmd("colorscheme rose-pine")
--    end
--}
