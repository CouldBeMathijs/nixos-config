{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "helix";
  cfg = config.${name};
  # Reference the external latex option
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
          # LaTeX Specific Binaries
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
        # Using flatten to merge the base list with the optional latex list
        language = lib.flatten [
          [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
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
              ];
            }
            {
              name = "markdown";
              auto-format = true;
              language-servers = [ "marksman" ];
            }
          ]
          (lib.optionals latexEnabled [
            {
              name = "latex";
              auto-format = true;
              language-servers = [
                "texlab"
                "ltex-ls"
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

        # Configure the LSP if latex is active
        language-server = lib.mkIf latexEnabled {
          ltex-ls = {
            command = "ltex-ls";
            config.ltex.language = "en-US";
          };
        };
      };
    };
  };
}
