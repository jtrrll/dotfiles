{ lib, ... }:
{
  extraConfigLuaPre = ''
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimOptionsDefaults",
      callback = function()
        for option, value in pairs(${
          lib.nixvim.toLuaObject {
            colorcolumn = "100,120";
            foldlevel = 5;
            guicursor = "n-v-sm:block-blinkon1,c-i-ve:ver25-blinkon1,r-cr-o:hor20-blinkon1";
            inccommand = "split";
            listchars = "extends:>,nbsp:_,precedes:<,tab:  ,trail:_";
            scrolloff = 8;
            showcmd = true;
            showcmdloc = "statusline";
            updatetime = 1000;
          }
        }) do
          vim.opt[option] = value
        end
      end,
    })
  '';
}
