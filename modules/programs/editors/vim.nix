{
  constants,
  pkgs,
  ...
}: {
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-code-dark
    ];
    settings = {
      expandtab = true;
      number = true;
      relativenumber = true;
      shiftwidth = constants.INDENT_WIDTH;
      tabstop = constants.INDENT_WIDTH;
      undofile = true;
    };
    extraConfig = ''
      " General
      filetype on               " detect filetype

      " Color
      set termguicolors         " enable 24-bit color
      syntax on                 " syntax highlighting
      colorscheme codedark      " set color scheme

      " UI
      set cursorline            " highlight current line
      set colorcolumn=${toString constants.LINE_LENGTH.WARNING},${toString constants.LINE_LENGTH.MAX} " highlight columns
      set signcolumn=yes        " always show the sign column
      set scrolloff=8           " attempt to keep space above/below the cursor

      " Indentation
      set autoindent            " auto-indent
      set shiftround            " always indent/outdent to nearest tabstop
      set smartindent           " automatically insert one extra level of indentation
      set nowrap                " don't wrap text

      " Input
      " switch between block and beam cursor shapes
      augroup cursorRefresh
        autocmd!
        autocmd BufEnter,InsertLeave,CmdlineLeave * silent !printf "\e[1 q"
        autocmd VimLeave,InsertEnter,CmdlineEnter * silent !printf "\e[5 q"
      augroup END
    '';
  };
}
