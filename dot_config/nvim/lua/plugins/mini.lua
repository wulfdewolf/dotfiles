vim.pack.add({
    { src = "https://github.com/echasnovski/mini.pick", name = "mini.pick" },
})
local MiniPick = require("mini.pick")
MiniPick.setup()
vim.keymap.set("n", "<C-f>", MiniPick.builtin.files, { desc = "Pick files (mini.pick)" })
vim.keymap.set("n", "<C-g>", MiniPick.builtin.grep_live, { desc = "Live grep (mini.pick)" })
