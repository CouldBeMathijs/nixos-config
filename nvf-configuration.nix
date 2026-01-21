{ ... }:
{
  vim = {
    viAlias = true;
    vimAlias = true;

    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    statusline.lualine = {
      enable = true;
    };

    telescope.enable = true;

    autocomplete.nvim-cmp.enable = true;

    lsp.enable = true;

    git.enable = true;

    languages = {
      enableTreesitter = true;
      enableFormat = true;

      nix.enable = true;
      python.enable = true;
      clang.enable = true;
      markdown.enable = true;
    };
  };
}
