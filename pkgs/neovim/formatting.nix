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
  '';
  plugins.lazy.plugins = lib.mkAfter [
    {
      __unkeyed = "stevearc/conform.nvim";
      opts.__raw = ''
        function(_, opts)
          local formatter_checks = {}
          local check_command = {
            "nix", "eval", "--no-write-lock-file", "--impure", "--raw", "--apply",
            'formatters: formatters.''${builtins.currentSystem}.drvPath',
            ".#formatter",
          }

          local function check_formatter(directory)
            local cached = formatter_checks[directory]
            if cached and (cached.pending or vim.uv.now() < cached.expires) then
              return cached
            end

            local check = {
              available = cached and cached.available or nil,
              pending = true,
              expires = 0,
            }
            formatter_checks[directory] = check
            vim.system(check_command, {
              cwd = directory,
              timeout = 10000,
              stdout = false,
              stderr = false,
            }, vim.schedule_wrap(function(result)
              if formatter_checks[directory] == check then
                check.available = result.code == 0
                check.pending = false
                check.expires = vim.uv.now() + 30000
              end
            end))
            return check
          end

          local function check_buffer(buf)
            local filename = vim.api.nvim_buf_get_name(buf)
            if filename == "" or vim.bo[buf].buftype ~= "" or vim.fn.executable("nix") ~= 1 then
              return nil
            end
            return check_formatter(vim.fs.dirname(filename))
          end

          local function flake_formatter_available(_, ctx)
            local check = check_buffer(ctx.buf)
            if check and check.available == nil then
              vim.wait(10000, function()
                return not check.pending
              end, 50)
            end
            return check ~= nil and check.available == true
          end

          vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
            callback = function(event)
              check_buffer(event.buf)
            end,
          })
          vim.schedule(function()
            check_buffer(vim.api.nvim_get_current_buf())
          end)

          opts.formatters.flake_fmt = {
            command = "nix",
            args = { "fmt", "--", "$FILENAME" },
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
