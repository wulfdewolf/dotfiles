local lsp_configs = {}
for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
    local server_name = vim.fn.fnamemodify(f, ':t:r')
    table.insert(lsp_configs, server_name)
end
vim.lsp.enable(lsp_configs)

require("config.options")
require("config.remap")

require("plugins.oil")
require("plugins.treesitter")
require("plugins.mason")
require("plugins.mini")
require("plugins.wordmotion")
require("plugins.cmp")
require("plugins.harpoon")
