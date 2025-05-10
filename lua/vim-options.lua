vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.api.nvim_set_option("clipboard", "unnamed")
vim.api.nvim_set_keymap('n', '<C-b>', ':e #<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-z>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<M-x>', function()
  -- Check if the current file is a Python file
  local filetype = vim.bo.filetype

  -- Run Ruff only if the file is Python
  if filetype == 'python' then
    -- Run Ruff directly to organize imports and apply fixes
    local filepath = vim.fn.expand("%:p")

    vim.fn.jobstart({ "ruff", "check", "--fix", filepath }, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, data)
        -- Capture standard output from Ruff
        if data then
          for _, line in ipairs(data) do
            print("Ruff output: " .. line)
          end
        end
      end,
      on_stderr = function(_, data)
        -- Capture error output from Ruff
        if data then
          for _, line in ipairs(data) do
            print("Ruff error: " .. line)
          end
        end
      end,
      on_exit = function(_, code)
        if code == 0 then
          -- Reload the buffer to reflect changes made by Ruff
          vim.cmd("edit!")

          -- Format the file via LSP
          vim.lsp.buf.format({ async = true })

          -- Write all files
          vim.cmd("wa")

          -- Get the list of windows in tmux
          local window_list = vim.fn.systemlist('tmux list-windows -F "#{window_index}"')
          local num_windows = #window_list
          if num_windows == 0 then
            print("No tmux windows found!")
            return
          end

          -- Get the current window index
          local current_window_index = tonumber(vim.fn.system('tmux display-message -p "#{window_index}"'))

          -- Calculate the previous window index, wrapping around
          local prev_window_index = (current_window_index - 2 + num_windows) % num_windows + 1

          -- Switch to the previous window
          local tmux_command = 'tmux select-window -t :' .. prev_window_index
          local result = vim.fn.systemlist(tmux_command)

          -- Check if there was an error running the tmux command
          if vim.v.shell_error ~= 0 then
            print("Error switching tmux window: " .. table.concat(result, "\n"))
          end
        else
          -- If Ruff fails, display an error message
          print("Ruff failed to fix the file (exit code: " .. code .. ").")
        end
      end,
    })
  else
    -- If not a Python file, just format and switch tmux window
    -- Format the file via LSP
    vim.lsp.buf.format({ async = true })

    -- Write all files
    vim.cmd("wa")

    -- Get the list of windows in tmux
    local window_list = vim.fn.systemlist('tmux list-windows -F "#{window_index}"')
    local num_windows = #window_list
    if num_windows == 0 then
      print("No tmux windows found!")
      return
    end

    -- Get the current window index
    local current_window_index = tonumber(vim.fn.system('tmux display-message -p "#{window_index}"'))

    -- Calculate the previous window index, wrapping around
    local prev_window_index = (current_window_index - 2 + num_windows) % num_windows + 1

    -- Switch to the previous window
    local tmux_command = 'tmux select-window -t :' .. prev_window_index
    local result = vim.fn.systemlist(tmux_command)

    -- Check if there was an error running the tmux command
    if vim.v.shell_error ~= 0 then
      print("Error switching tmux window: " .. table.concat(result, "\n"))
    end
  end
end, { noremap = true, silent = true })

