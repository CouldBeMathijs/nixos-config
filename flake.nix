{
        description = "The main flake";

        inputs = {
                asus-numberpad-driver = {
                        url = "github:asus-linux-drivers/asus-numberpad-driver";
                        inputs.nixpkgs.follows = "nixpkgs";
                };
                home-manager = {
                        url = "github:nix-community/home-manager/master";
                        inputs.nixpkgs.follows = "nixpkgs";
                };
                gruvbox-icons = {
                        url = "github:SylEleuth/gruvbox-plus-icon-pack/master";
                        flake = false;
                };
                my-bash-scripts = {
                        url = "github:CouldBeMathijs/bash-scripts";
                        flake = false;
                };
                niri = {
                        url = "github:sodiboo/niri-flake";
                        inputs.nixpkgs.follows = "nixpkgs";
                };
                nixpkgs = {
                        url = "github:NixOS/nixpkgs/nixos-unstable";
                };
                nixpkgs-stable = {
                        url = "github:NixOS/nixpkgs/release-25.05";
                };
                nix-index-database = {
                        url = "github:nix-community/nix-index-database";
                        inputs.nixpkgs.follows = "nixpkgs";
                };
                nvf = {
                        url = "github:NotAShelf/nvf/v0.8";
                        inputs.nixpkgs.follows = "nixpkgs";
                };
                stylix = {
                        url = "github:nix-community/stylix/master";
                        inputs.nixpkgs.follows = "nixpkgs";
                };
                zen-browser = {
                        url = "github:0xc000022070/zen-browser-flake/beta";
                        inputs.nixpkgs.follows = "nixpkgs";
                };
        };

        outputs = {
                asus-numberpad-driver,
                gruvbox-icons,
                home-manager,
                my-bash-scripts,
                niri,
                nix-index-database,
                nixpkgs,
                nixpkgs-stable,
                nvf,
                stylix,
                zen-browser,
                ...
                }:
                let
                        system = "x86_64-linux";
                        lib = nixpkgs.lib;

                        pkgs = import nixpkgs {
                                inherit system;
                                config.allowUnfree = true;
                        };

                        pkgs-stable = import nixpkgs-stable {
                                inherit system;
                                config.allowUnfree = true;
                        };

                        # Custom bash scripts package
                        my-bash-scripts-pkg = pkgs.stdenv.mkDerivation {
                                pname = "my-bash-scripts";
                                version = "1.0.0";
                                src = my-bash-scripts;
                                installPhase = ''
                mkdir -p $out/bin
                for script in $src/*.sh; do
                    base_name=$(basename "$script" .sh)
                    cp "$script" "$out/bin/$base_name"
                    chmod +x "$out/bin/$base_name"
                done
                                '';
                        };

                        # Neovim config using NVF
                        my-neovim-pkg = (nvf.lib.neovimConfiguration {
                                pkgs = nixpkgs.legacyPackages."${system}";
                                modules = [ ./nvf-configuration.nix ];
                        }).neovim;

                        # Gruvbox icon pack derivation
                        gruvbox-plus-icons-git = pkgs.callPackage ./packages/gruvbox-plus-icons-git.nix {
                                inherit gruvbox-icons system;
                        };

                        # Function to create a NixOS system configuration
                        mkHost = { hostname, modules }: lib.nixosSystem {
                                inherit system;
                                modules = modules ++ [
                                        nix-index-database.nixosModules.nix-index
                                        { programs.nix-index-database.comma.enable = true; }
                                        niri.nixosModules.niri
                                ];
                                specialArgs = {
                                        inherit pkgs-stable niri;
                                };
                        };

                        # Function to create a Home Manager configuration
                        mkHome = { username, hostname, homeModules }: home-manager.lib.homeManagerConfiguration {
                                inherit pkgs;
                                modules = homeModules ++ [
                                        {
                                                home.packages = [
                                                        my-bash-scripts-pkg
                                                        my-neovim-pkg
                                                ];
                                        }
                                        stylix.homeModules.stylix
                                        niri.homeModules.niri
                                ];
                                extraSpecialArgs = {
                                        inherit
                                        gruvbox-plus-icons-git
                                        niri
                                        pkgs-stable
                                        zen-browser;
                                };
                        };


                in {
                        # Default app for `nix run .`
                        defaultApp."${system}" = {
                                type = "app";
                                program = "${my-neovim-pkg}/bin/nvim";
                        };

                        nixosConfigurations = {
                                athena = mkHost {
                                        hostname = "athena";
                                        modules = [
                                                ./hosts/athena/hardware-configuration.nix
                                                ./hosts/athena/configuration.nix
                                                asus-numberpad-driver.nixosModules.default
                                        ];
                                };

                                dionysus = mkHost {
                                        hostname = "dionysus";
                                        modules = [
                                                ./hosts/dionysus/configuration.nix
                                                ./hosts/dionysus/hardware-configuration.nix
                                        ];
                                };
                        };

                        homeConfigurations = {
                                "mathijs@athena" = mkHome {
                                        username = "mathijs";
                                        hostname = "athena";
                                        homeModules = [
                                                ./hosts/athena/home.nix
                                        ];
                                };

                                "mathijs@dionysus" = mkHome {
                                        username = "mathijs";
                                        hostname = "dionysus";
                                        homeModules = [
                                                ./hosts/dionysus/home.nix
                                        ];
                                };
                        };
                };
}

