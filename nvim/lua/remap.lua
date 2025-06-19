vim.api.nvim_set_keymap('n', '<C-b>', ':e #<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-z>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>x', function()
    vim.cmd("wa")
    local result = vim.fn.systemlist('tmux select-window -t :-')
    if vim.v.shell_error ~= 0 then
        print("Error switching tmux window: " .. table.concat(result, "\n"))
    end
end, { noremap = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set('n', 'gs', function()
    vim.cmd('vsplit')
    vim.lsp.buf.definition()
end, { noremap = true, silent = true })
vim.keymap.set('n', 'gS', function()
    vim.cmd('hsplit')
    vim.lsp.buf.definition()
end, { noremap = true, silent = true })

local diagnostics_on = false
vim.keymap.set('n', '<leader>d', function()
    diagnostics_on = not diagnostics_on
    vim.diagnostic.config({ virtual_text = diagnostics_on })
end, { noremap = true, silent = true })

local uv = vim.loop

vim.api.nvim_create_user_command("SendCodeToTmuxTmpRun", function(opts)
    local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

    for i, line in ipairs(lines) do
        lines[i] = line:gsub("^%s*>>>%s*", "")
    end

    local tmpfile = "/tmp/nvim_tmp_run.py"
    local fd = uv.fs_open(tmpfile, "w", 438)
    uv.fs_write(fd, table.concat(lines, "\n"), -1)
    uv.fs_close(fd)

    local handle = io.popen("tmux display-message -p '#S'")
    local session_name = handle:read("*a"):gsub("%s+", "")
    handle:close()

    -- Check if tmux window named 'ex' exists, kill it if yes
    local check_cmd = string.format("tmux list-windows -t %s -F '#{window_name}' | grep -w ex", session_name)
    local check_handle = io.popen(check_cmd)
    local exists = check_handle:read("*a")
    check_handle:close()

    if exists ~= "" then
        os.execute(string.format("tmux kill-window -t %s:ex", session_name))
    end

    os.execute(string.format("tmux new-window -n ex -t %s 'uv run python -i %s'", session_name, tmpfile))
    os.execute(string.format("tmux select-window -t %s:ex", session_name))
end, { range = true })

-- Visual mode map to send selection to command
vim.keymap.set('v', '<C-r>', ":'<,'>SendCodeToTmuxTmpRun<CR>", { noremap = true, silent = true })
