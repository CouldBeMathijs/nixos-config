{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "helix";
  cfg = config.${name};
  latexEnabled = config.latex.enable;
in
{
  options.helix = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      defaultEditor = true;

      extraPackages =
        with pkgs;
        [
          # Universal color & snippet LSP
          hx-lsp
          # Nix
          nil
          nixfmt
          # C++
          clang-tools
          # Python
          basedpyright
          ruff
          # Bash
          bash-language-server
          shellcheck
          shfmt
          # Markdown
          marksman
        ]
        ++ lib.optionals latexEnabled [
          texlab
          ltex-ls
          texlivePackages.latexindent
        ];

      settings = {
        theme = "gruvbox";
        editor = {
          line-number = "relative";
          cursorline = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };
      };

      languages = {
        language = lib.flatten [
          [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
              language-servers = [
                "nil"
                "hx-lsp"
              ];
            }
            {
              name = "python";
              auto-format = true;
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
                "hx-lsp"
              ];
            }
            {
              name = "markdown";
              auto-format = true;
              language-servers = [
                "marksman"
                "hx-lsp"
              ];
            }
            {
              name = "bash";
              language-servers = [
                "bash-language-server"
                "hx-lsp"
              ];
            }
            {
              name = "cpp";
              language-servers = [
                "clangd"
                "hx-lsp"
              ];
            }
          ]
          (lib.optionals latexEnabled [
            {
              name = "latex";
              auto-format = true;
              language-servers = [
                "texlab"
                "ltex-ls"
                "hx-lsp"
              ];
              formatter = {
                command = "latexindent";
                args = [
                  "-g"
                  "/dev/null"
                ];
              };
            }
          ])
        ];

        language-server = {
          hx-lsp = {
            command = "${pkgs.hx-lsp}/bin/hx-lsp";
          };
        }
        // lib.optionalAttrs latexEnabled {
          ltex-ls = {
            command = "ltex-ls";
            config.ltex.language = "en-US";
          };
        };
      };
    };
  };
}
