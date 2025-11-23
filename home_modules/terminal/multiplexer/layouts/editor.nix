{
  claude,
  default_tab_template,
  neovim,
}:
{
  layout._children = [
    {
      inherit default_tab_template;
    }
    {
      tab = {
        _props = {
          focus = true;
          split_direction = "vertical";
        };
        _children = [
          {
            pane = {
              name = "claude";
              command = claude;
              focus = true;
              size = "25%";
            };
          }
          {
            pane = {
              _props.size = "75%";
              _children = [
                {
                  pane = {
                    name = "neovim";
                    command = neovim;
                    focus = true;
                    size = "75%";
                  };
                }
                {
                  pane = {
                    name = "workspace";
                    size = "25%";
                  };
                }
              ];
            };
          }
        ];
      };
    }
  ];
}
