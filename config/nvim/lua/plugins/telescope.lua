return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')
        telescope.setup({
            defaults = {
                mappings = {
                    n = {
                        ["<C-x>"] = false,
                        ["s"] = actions.select_vertical,
                        ["S"] = actions.select_horizontal,
                    },
                },
            },
        })
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<C-f>', function()
            require('telescope.builtin').find_files({
                hidden = true,                       -- include hidden files
                no_ignore = true,
                file_ignore_patterns = { "^.git/", "^.venv/"}, -- exclude .git directory
            })
        end, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<C-g>', function()
            require('telescope.builtin').live_grep({
                hidden = true,                       -- include hidden files
                no_ignore = true,
                file_ignore_patterns = { "^.git/", "^.venv/"}, -- exclude .git directory
            })
        end, { desc = 'Telescope live grep' })
    end
}
