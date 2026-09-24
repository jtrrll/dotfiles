{
  extraConfigLuaPre = ''
    local last_command = ""
    local command_complete = true
    local command_line_text = nil
    local previous_command = ""
    local typed_colon = false

    vim.on_key(function(_, typed)
      if typed == "" or vim.api.nvim_get_mode().mode:sub(1, 1) ~= "n" then
        return
      end

      local key = vim.fn.keytrans(typed)
      typed_colon = key == ":"
      if key == ":" and command_complete then
        previous_command = last_command
      end
      local prefix = vim.api.nvim_eval_statusline("%S", {}).str
      if prefix ~= "" and prefix:match("^[%w<>%-%_ ]+$") then
        last_command = #key > #prefix and key:sub(1, #prefix) == prefix and key or prefix .. key
      else
        last_command = (command_complete and "" or last_command) .. key
      end
      command_complete = false
      vim.cmd.redrawstatus()
    end, vim.api.nvim_create_namespace("normal-command-display"))

    vim.api.nvim_create_autocmd("SafeState", {
      callback = function()
        command_complete = true
      end,
    })

    vim.api.nvim_create_autocmd("CmdlineEnter", {
      pattern = ":",
      callback = function()
        if not typed_colon then
          return
        end
        command_line_text = ":"
        vim.cmd.redrawstatus()
      end,
    })

    vim.api.nvim_create_autocmd("CmdlineChanged", {
      pattern = ":",
      callback = function()
        if not command_line_text then
          return
        end
        command_line_text = ":" .. vim.fn.getcmdline()
        vim.cmd.redrawstatus()
      end,
    })

    vim.api.nvim_create_autocmd("CmdlineLeave", {
      pattern = ":",
      callback = function()
        if not command_line_text then
          return
        end
        if vim.v.event.abort == true or vim.v.event.abort == 1 then
          last_command = previous_command
        else
          last_command = ":" .. vim.fn.getcmdline()
        end
        command_line_text = nil
        typed_colon = false
        command_complete = true
        vim.cmd.redrawstatus()
      end,
    })

    _G.command_status = function()
      if command_line_text then
        return command_line_text
      end
      local partial_command = vim.api.nvim_eval_statusline("%S", {}).str
      if partial_command ~= "" and partial_command:match("^[%w<>%-%_ ]+$") then
        return partial_command
      end
      return last_command
    end

    _G.command_statusline = function()
      return "%{v:lua._G.command_status()}"
    end
  '';
}
