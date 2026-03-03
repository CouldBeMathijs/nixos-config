{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "zed";
  cfg = config.${name};
  latexEnabled = config.latex.enable or false;
in
{
  options.${name} = {
    enable = lib.mkEnableOption "Enable my ${name} configuration";
  };

  config = lib.mkIf cfg.enable {
    # System packages required for Language Servers
    home.packages =
      with pkgs;
      [
        nil # Nix LSP
        pyright # Python LSP
        clang-tools # C/C++ LSP (clangd)
      ]
      ++ lib.optionals latexEnabled [
        texlab # LaTeX LSP
        zathura # PDF Viewer
      ];

    programs.zed-editor = {
      enable = true;

      userSettings = {
        # --- UI & Window Management ---
        "theme" = "Gruvbox Dark";

        "project_panel" = {
          "dock" = "left";
          "default_width" = 240;
        };

        # --- Modal Editing (Helix) ---
        "helix_mode" = true;
        "autosave" = "on_window_change";
        "ui_font_size" = 18;
        "buffer_font_size" = 14;

        # --- Languages ---
        "languages" = {
          "Nix" = {
            "language_servers" = [ "nil" ];
            "format_on_save" = "on";
          };
          "Python" = {
            "language_servers" = [ "pyright" ];
            "format_on_save" = "on";
          };
          "C" = {
            "language_servers" = [ "clangd" ];
            "format_on_save" = "on";
          };
          "C++" = {
            "language_servers" = [ "clangd" ];
            "format_on_save" = "on";
          };
        }
        # Inject LaTeX if global option is enabled
        // lib.optionalAttrs latexEnabled {
          "LaTeX" = {
            "language_servers" = [ "texlab" ];
            "format_on_save" = "on";
            "soft_wrap" = "editor_width";
          };
        };

        # --- LSP Specifics ---
        "lsp" = lib.optionalAttrs latexEnabled {
          "texlab" = {
            "settings" = {
              "texlab" = {
                "build" = {
                  "onSave" = true;
                  "executable" = "latexmk";
                  "args" = [
                    "-pdf"
                    "-interaction=nonstopmode"
                    "-synctex=1"
                    "%f"
                  ];
                };
                "forwardSearch" = {
                  "executable" = "zathura";
                  "args" = [
                    "--synctex-forward"
                    "%l:1:%f"
                    "%p"
                  ];
                };
              };
            };
          };
        };
      };

      # Optional: Helix-specific keybinding overrides
      userKeymaps = [
        {
          "context" = "Editor && mode == full";
          "bindings" = {
            # Add any specific Helix tweaks here if the default preset is missing one
          };
        }
      ];
    };
  };
}
