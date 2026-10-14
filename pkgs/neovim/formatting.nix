{ lib, ... }:
{
  extraConfigLuaPre = ''
    local quitting_after_write = false
    local write_and_quit_commands = {
      wq = true,
      wqa = true,
      wqall = true,
      x = true,
      xit = true,
      exit = true,
    }

    vim.api.nvim_create_autocmd("CmdlineLeave", {
      pattern = ":",
      callback = function()
        local command = vim.fn.getcmdline():match("^%s*(%a+)")
        local aborted = vim.v.event.abort == true or vim.v.event.abort == 1
        quitting_after_write = not aborted and write_and_quit_commands[command] == true
      end,
    })

    vim.api.nvim_create_autocmd("SafeState", {
      callback = function()
        quitting_after_write = false
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = function()
        local format = LazyVim.format.format
        LazyVim.format.format = function(format_opts)
          format_opts = format_opts or {}
          local buf = format_opts.buf or vim.api.nvim_get_current_buf()
          local skip_notification = quitting_after_write and not format_opts.force
          quitting_after_write = false
          if skip_notification or (not format_opts.force and not LazyVim.format.enabled(buf)) then
            return format(format_opts)
          end

          local filename = vim.api.nvim_buf_get_name(buf)
          local name = filename ~= "" and vim.fs.basename(filename) or "[No Name]"
          local notification = Snacks.notifier.notify("Formatting " .. name .. "…", "info", {
            title = "Formatting",
            timeout = 0,
            history = false,
          })
          vim.wait(60)
          local ok, result = pcall(format, format_opts)
          Snacks.notifier.hide(notification)
          if not ok then
            error(result)
          end
          return result
        end
      end,
    })

    local flake_formatters = {}
    local formatter_max_age_ms = 5 * 60 * 1000
    local eval_command = {
      "nix", "eval", "--no-write-lock-file", "--impure", "--raw", "--apply",
      [[formatters:
        let formatter = formatters.''${builtins.currentSystem}; in
        "''${formatter}/bin/''${formatter.meta.mainProgram or (builtins.parseDrvName formatter.name).name}\n''${formatter.drvPath}"
      ]],
      ".#formatter",
    }

    local function flake_stamp(root)
      return vim.iter({ "flake.nix", "flake.lock" })
        :map(function(name)
          local stat = vim.uv.fs_stat(root .. "/" .. name)
          return stat and (stat.mtime.sec .. "." .. stat.mtime.nsec) or "-"
        end)
        :join(":")
    end

    local function resolve_formatter(root, entry)
      entry.pending = true
      entry.stamp = flake_stamp(root)
      entry.resolved_at = vim.uv.now()

      local function finish(command)
        entry.command = command
        entry.checked = true
        entry.pending = false
      end

      vim.system(eval_command, { cwd = root, timeout = 30000 }, vim.schedule_wrap(function(eval)
        local executable, derivation = eval.stdout:match("^(.-)\n(.-)%s*$")
        if eval.code ~= 0 or not executable then
          return finish(nil)
        end
        if vim.uv.fs_stat(executable) then
          return finish(executable)
        end
        vim.system({ "nix-store", "--realise", derivation }, { timeout = 600000 }, vim.schedule_wrap(function(realise)
          finish(realise.code == 0 and executable or nil)
        end))
      end))
    end

    local function flake_formatter(buf)
      local filename = vim.api.nvim_buf_get_name(buf)
      if filename == "" or vim.bo[buf].buftype ~= "" or vim.fn.executable("nix") ~= 1 then
        return nil
      end
      local root = vim.fs.root(filename, "flake.nix")
      if not root then
        return nil
      end

      local entry = flake_formatters[root]
      if not entry then
        entry = { checked = false, pending = false }
        flake_formatters[root] = entry
        resolve_formatter(root, entry)
      elseif not entry.pending
        and (entry.stamp ~= flake_stamp(root) or vim.uv.now() - entry.resolved_at > formatter_max_age_ms)
      then
        resolve_formatter(root, entry)
      end
      return entry
    end

    _G.flake_formatter = flake_formatter

    vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
      callback = function(event)
        flake_formatter(event.buf)
      end,
    })
  '';
  plugins.lazy.plugins = lib.mkAfter [
    {
      __unkeyed = "stevearc/conform.nvim";
      opts.__raw = ''
        function(_, opts)
          local function flake_formatter_available(_, ctx)
            local entry = _G.flake_formatter(ctx.buf)
            if entry and not entry.checked then
              vim.notify("Flake formatter is still resolving; skipping format", vim.log.levels.WARN)
            end
            return entry ~= nil and entry.command ~= nil
          end

          opts.formatters.flake_fmt = {
            command = function(_, ctx)
              local entry = _G.flake_formatter(ctx.buf)
              return entry and entry.command or "nix"
            end,
            args = { "$FILENAME" },
            stdin = false,
            cwd = function(_, ctx)
              return vim.fs.dirname(ctx.filename)
            end,
            condition = flake_formatter_available,
          }
          opts.formatters_by_ft = { ["*"] = { "flake_fmt" } }
          opts.default_format_opts.timeout_ms = 30000
          return opts
        end
      '';
    }
  ];
}
