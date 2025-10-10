{
        description = "The main flake";

        inputs = {
                nixpkgs.url = "nixpkgs/nixos-25.05";
                nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

                home-manager = {
                        url = "github:nix-community/home-manager/release-25.05";
                        inputs.nixpkgs.follows = "nixpkgs";
                };

                asus-numberpad-driver = {
                        url = "github:asus-linux-drivers/asus-numberpad-driver";
                        inputs.nixpkgs.follows = "nixpkgs";
                };

                nix-index-database = {
                        url = "github:nix-community/nix-index-database";
                        inputs.nixpkgs.follows = "nixpkgs";
                };

                my-bash-scripts = {
                        url = "github:CouldBeMathijs/bash-scripts";
                        flake = false;
                };

                nvf = {
                        url = "github:NotAShelf/nvf/v0.8";
                        inputs.nixpkgs.follows = "nixpkgs";
                };

                gruvbox-icons = {
                        url = "github:SylEleuth/gruvbox-plus-icon-pack/master";
                        flake = false;
                };

                zen-browser = {
                        url = "github:0xc000022070/zen-browser-flake/beta";
                        inputs.nixpkgs.follows = "nixpkgs";
                };
                nixos-hardware.url = "github:nixos/nixos-hardware/master";
        };

        outputs = {
                nixpkgs,
                nixpkgs-unstable,
                home-manager,
                asus-numberpad-driver,
                nix-index-database,
                my-bash-scripts,
                nvf,
                gruvbox-icons,
                zen-browser,
                nixos-hardware,
                ...
                }:
                let
                        system = "x86_64-linux";
                        lib = nixpkgs.lib;

                        pkgs = import nixpkgs {
                                inherit system;
                                config.allowUnfree = true;
                        };

                        pkgs-unstable = import nixpkgs-unstable {
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
                        gruvboxPlusIcons = pkgs.callPackage ./packages/gruvbox-plus-icons.nix {
                                inherit gruvbox-icons system;
                        };

                in {
                        # Default app for `nix run .`
                        defaultApp."${system}" = {
                                type = "app";
                                program = "${my-neovim-pkg}/bin/nvim";
                        };

                        nixosConfigurations = {
                                athena = lib.nixosSystem {
                                        inherit system;
                                        modules = [
                                                ./hosts/athena/hardware-configuration.nix
                                                ./hosts/athena/configuration.nix
                                                asus-numberpad-driver.nixosModules.default
                                                nix-index-database.nixosModules.nix-index
                                                { programs.nix-index-database.comma.enable = true; }
                                        ];
                                        specialArgs = {
                                                inherit pkgs-unstable;
                                        };
                                };

                                dionysus = lib.nixosSystem {
                                        inherit system;
                                        modules = [
                                                ./hosts/dionysus/configuration.nix
                                                ./hosts/dionysus/hardware-configuration.nix
                                                nix-index-database.nixosModules.nix-index
                                                { programs.nix-index-database.comma.enable = true; }
                                                #nixos-hardware.nixosModules.lenovo-legion-15ach6h-nvidia
                                        ];
                                        specialArgs = {
                                                inherit pkgs-unstable;
                                        };
                                };
                        };

                        homeConfigurations = {
                                "mathijs@athena" = home-manager.lib.homeManagerConfiguration {
                                        inherit pkgs;
                                        modules = [
                                                ./hosts/athena/home.nix
                                                {
                                                        home.packages = [
                                                                my-bash-scripts-pkg
                                                                my-neovim-pkg
                                                        ];
                                                }
                                        ];
                                        extraSpecialArgs = {
                                                inherit pkgs-unstable gruvboxPlusIcons zen-browser;
                                        };
                                };

                                "mathijs@dionysus" = home-manager.lib.homeManagerConfiguration {
                                        inherit pkgs;
                                        modules = [
                                                ./hosts/dionysus/home.nix
                                                {
                                                        home.packages = [
                                                                my-bash-scripts-pkg
                                                                my-neovim-pkg
                                                        ];
                                                }
                                        ];
                                        extraSpecialArgs = {
                                                inherit pkgs-unstable gruvboxPlusIcons zen-browser;
                                        };
                                };
                        };
                };
}

