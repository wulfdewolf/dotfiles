vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    {
        src = "https://github.com/ThePrimeagen/harpoon.git",
        version = "harpoon2",
    },
})
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<M-a>", function() harpoon:list():add() end)
vim.keymap.set("n", "=", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<M-1>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<M-2>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<M-3>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<M-4>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<M-h>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<M-l>", function() harpoon:list():next() end)

vim.keymap.set("n", "<M-=>", function()
    harpoon:list():clear()
end, { desc = "Harpoon: clear list" })
