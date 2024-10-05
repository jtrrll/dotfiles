{
  config,
  constants,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.opts = {
      breakindent = true; # indent wrapped lines
      clipboard = "unnamedplus"; # use system clipboard
      colorcolumn = "${toString constants.LINE_LENGTH.WARNING},${toString constants.LINE_LENGTH.MAX}"; # highlight columns
      cursorline = true; # highlight current line
      expandtab = true; # use spaces instead of tabs
      foldlevel = 3; # the fold levels that should be open to start
      foldmethod = "indent"; # automatically define folds by indent
      guicursor = "n-sm-v-:block,c-ci-i-ve:ver25,r-cr-o:hor20"; # set cursor shape for various modes
      inccommand = "split"; # preview substitutions
      list = true; # show characters in white spaces
      listchars = "extends:>,nbsp:_,precedes:<,tab:  ,trail:_"; # characters to use in list mode
      mouse = "a"; # enable mouse control
      number = true; # show line numbers
      relativenumber = true; # show relative line numbers
      scrolloff = 8; # number of lines to preserve above/below the cursor
      shiftround = true; # indent to nearest indent level
      shiftwidth = constants.INDENT_WIDTH; # spaces per indent level
      showmode = false; # hide current mode because it is in the status line
      signcolumn = "yes"; # always show the sign column
      smartindent = true; # automatically indent once when appropriate
      splitbelow = true; # open new horizontal splits below the current window
      splitright = true; # open new vertical splits to the right of the current window
      tabstop = constants.INDENT_WIDTH; # number of spaces per tab
      termguicolors = true; # enable 24-bit color
      undofile = true; # persist undo history
      updatetime = 1000; # milliseconds of inactivity until cursor is deemed idle
      wrap = false; # don't wrap text
    };
  };
}
