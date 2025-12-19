{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.editors.neovim.enable {
    programs.nixvim.opts = {
      breakindent = true; # indent wrapped lines
      colorcolumn = lib.concatStringsSep "," (map toString config.dotfiles.editors.lineLengthRulers); # highlight columns
      cursorline = true; # highlight current line
      expandtab = true; # use spaces instead of tabs
      foldlevel = 5; # the fold levels that should be open to start
      guicursor = "n-v-sm:block-blinkon1,c-i-ve:ver25-blinkon1,r-cr-o:hor20-blinkon1"; # set cursor shape for various modes
      inccommand = "split"; # preview substitutions
      list = true; # show characters in white spaces
      listchars = "extends:>,nbsp:_,precedes:<,tab:  ,trail:_"; # characters to use in list mode
      mouse = "a"; # enable mouse control
      number = true; # show line numbers
      relativenumber = true; # show relative line numbers
      scrolloff = config.dotfiles.editors.linesAroundCursor; # number of lines to preserve above/below the cursor
      shiftround = true; # indent to nearest indent level
      shiftwidth = config.dotfiles.editors.indentWidth; # spaces per indent level
      showmode = false; # hide current mode because it is in the status line
      signcolumn = "yes"; # always show the sign column
      smartindent = true; # automatically indent once when appropriate
      splitbelow = true; # open new horizontal splits below the current window
      splitright = true; # open new vertical splits to the right of the current window
      tabstop = config.dotfiles.editors.indentWidth; # number of spaces per tab
      termguicolors = true; # enable 24-bit color
      undofile = true; # persist undo history
      updatetime = 1000; # milliseconds of inactivity until cursor is deemed idle
      wrap = false; # don't wrap text
    };
  };
}
