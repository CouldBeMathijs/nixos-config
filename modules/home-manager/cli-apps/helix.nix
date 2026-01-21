{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    helix.enable = lib.mkEnableOption "enable helix";
  };

  config = lib.mkIf config.helix.enable {
    programs.helix = {
      enable = true;
      defaultEditor = true;

      extraPackages = with pkgs; [
        # Nix
        nil
        nixfmt
        # C/C++
        clang-tools # Provides clangd (LSP) and clang-format
        # Python
        basedpyright # Modern LSP (better than standard pyright)
        ruff # Extremely fast Linter + Formatter
        # Bash
        bash-language-server
        shellcheck # Static analysis for bash
        shfmt # Formatter for bash
      ];

      settings = {
        theme = "gruvbox";
        editor = {
          line-number = "relative";
          cursorline = true;
          color-modes = true;
          lsp.display-messages = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
          }
          {
            name = "python";
            auto-format = true;
            # Use Ruff for formatting (much faster than Black)
            formatter = {
              command = "ruff";
              args = [
                "format"
                "-"
              ];
            };
            language-servers = [
              "basedpyright"
              "ruff"
            ];
          }
          {
            name = "cpp";
            auto-format = true;
            formatter = {
              command = "clang-format";
            };
          }
          {
            name = "bash";
            auto-format = true;
            formatter = {
              command = "shfmt";
              args = [
                "-i"
                "2"
              ];
            };
          }
        ];

        # Define specific LSP behavior if needed
        language-server.basedpyright.config.basedpyright.analysis.typeCheckingMode = "standard";
      };
    };
  };
}
