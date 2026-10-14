{
  extraConfigLuaPre = ''
    local function linter_installed(lint, name)
      local linter = lint.linters[name]
      if type(linter) == "function" then
        linter = linter()
      end
      if type(linter) ~= "table" then
        return true
      end
      local command = linter.cmd
      if type(command) == "function" then
        command = command()
      end
      return type(command) ~= "string" or vim.fn.executable(command) == 1
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data ~= "nvim-lint" then
          return
        end

        local lint = require("lint")
        local try_lint = lint.try_lint
        lint.try_lint = function(names, opts)
          names = names or lint._resolve_linter_by_ft(vim.bo.filetype)
          if type(names) == "string" then
            names = { names }
          end
          names = vim.tbl_filter(function(name)
            return linter_installed(lint, name)
          end, names)
          if #names == 0 then
            return
          end
          return try_lint(names, opts)
        end
        return true
      end,
    })
  '';
}
