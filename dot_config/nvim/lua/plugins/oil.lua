return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, for file icons
    cmd = "Oil",
    keys = {
        { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },
    opts = {
        default_file_explorer = true,
        view_options = {
            show_hidden = true,
        },
    },
}
