{ pkgs, lib, config, options, ... }:
{
        options = {
                gramps.enable = lib.mkEnableOption "Enable gramps configuration";
        };

        config = lib.mkIf config.gramps.enable {
                home.packages = [
                        (pkgs.gramps.overrideAttrs (oldAttrs: {
                                src = pkgs.fetchFromGitHub {
                                        owner = "gramps-project";
                                        repo = "gramps";
                                        rev = "v6.0.4";
                                        hash = "sha256-MBsc4YMbCvzRG6+7/cGQpx7iYvQAdqWYrIMEpf1A7ew=";
                                };
                                version = "6.0.4";

                                propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
                                        pkgs.python3Packages.orjson
                                ];

                                patches = builtins.filter (p:
                                        let
                                                patchName = builtins.toString p;
                                                suffix = "disable-gtk-warning-dialog.patch";
                                        in
                                                builtins.substring (builtins.stringLength patchName - builtins.stringLength suffix) (builtins.stringLength suffix) patchName != suffix
                                ) oldAttrs.patches;
                        }))

                ];
        };
}
