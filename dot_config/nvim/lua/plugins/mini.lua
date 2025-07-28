return {
    "echasnovski/mini.pick",
    version = false, -- Use latest
    lazy = false,  -- Load immediately (or true if you want lazy load)
    config = function()
        require("mini.pick").setup()

        -- Set keybindings
        vim.keymap.set("n", "<C-f>", MiniPick.builtin.files, { desc = "Pick files (mini.pick)" })
        vim.keymap.set("n", "<C-g>", MiniPick.builtin.grep_live, { desc = "Live grep (mini.pick)" })
    end,
}
