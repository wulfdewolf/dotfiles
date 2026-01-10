vim.pack.add({
    { src = "https://github.com/hrsh7th/nvim-cmp",     name = "nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp", name = "cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer",   name = "cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path",     name = "cmp-path" },
})
local cmp = require("cmp")
cmp.setup({
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    },
})
