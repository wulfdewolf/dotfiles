vim.api.nvim_set_keymap('n', '<C-b>', ':e #<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-z>', '<Nop>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>x', function()
    vim.cmd("wa") -- Save all

    -- Gather real .py file paths from open buffers
    local buffers = vim.api.nvim_list_bufs()
    local files = {}
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "modifiable") then
            local path = vim.api.nvim_buf_get_name(buf)
            if path ~= "" and vim.endswith(path, ".py") and vim.loop.fs_stat(path) then
                table.insert(files, path)
            end
        end
    end

    if #files == 0 then
        print("No Python files to run check/fix on.")
        return
    end

    -- Step 1: Run uv run ruff check --fix
    local check_cmd = { "uv", "run", "ruff", "check", "--fix", unpack(files) }
    local check_result = vim.fn.systemlist(check_cmd)
    if vim.v.shell_error ~= 0 then
        print("uv run ruff check --fix failed:\n" .. table.concat(check_result, "\n"))
        return
    end

    -- Step 2: Run uv run ruff format
    local format_cmd = { "uv", "run", "ruff", "format", unpack(files) }
    local format_result = vim.fn.systemlist(format_cmd)
    if vim.v.shell_error ~= 0 then
        print("uv run ruff format failed:\n" .. table.concat(format_result, "\n"))
        return
    end

    -- Step 3: Reload all modified files from disk
    for _, file in ipairs(files) do
        local bufnr = vim.fn.bufnr(file)
        if bufnr ~= -1 then
            vim.api.nvim_buf_call(bufnr, function()
                vim.cmd("checktime")
            end)
        end
    end

    -- Step 4: Switch to previous tmux window
    local tmux_result = vim.fn.systemlist('tmux select-window -t :-')
    if vim.v.shell_error ~= 0 then
        print("Error switching tmux window:\n" .. table.concat(tmux_result, "\n"))
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
    -- 1 · collect the visually‑selected lines
    local raw_lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

    -- 2 · strip >>> and ... prompts, keep everything else
    local lines = {}
    for _, line in ipairs(raw_lines) do
        -- match >>> prompt first …
        local code = line:match("^%s*>>>%s*(.*)")
        -- … then match continuation prompt if the first failed
        if not code then
            code = line:match("^%s*%.%.%.%s*(.*)")
        end
        -- keep only lines that actually had a prompt
        if code and code ~= "" then
            table.insert(lines, code)
        end
    end
    if #lines == 0 then
        vim.notify("Selection has no >>> or ... prompt lines", vim.log.levels.WARN)
        return
    end

    -- 3 · write to temp file
    local tmpfile = "/tmp/nvim_tmp_run.py"
    local fd      = uv.fs_open(tmpfile, "w", 438)
    uv.fs_write(fd, table.concat(lines, "\n"), -1)
    uv.fs_close(fd)

    -- 4 · open/refresh the tmux window “ex”
    local session_name = io.popen("tmux display-message -p '#S'"):read("*a"):gsub("%s+", "")
    if io.popen(("tmux list-windows -t %s -F '#{window_name}' | grep -w ex"):format(session_name)):read("*a") ~= "" then
        os.execute(("tmux kill-window -t %s:ex"):format(session_name))
    end
    os.execute(("tmux new-window -n ex -t %s 'uv run python -i %s'"):format(session_name, tmpfile))
    os.execute(("tmux select-window -t %s:ex"):format(session_name))
end, { range = true })

-- visual‑mode shortcut
vim.keymap.set('v', '<C-r>', ":'<,'>SendCodeToTmuxTmpRun<CR>", { noremap = true, silent = true })
