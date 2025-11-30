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
                        # Concrete system used for internal packages (since they must be built once)
                        internalSystem = "x86_64-linux";
                        lib = nixpkgs.lib;

                        # Packages for the internalSystem, used by home.packages and defaultApp
                        pkgs = import nixpkgs {
                                system = internalSystem;
                                config.allowUnfree = true;
                        };

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

                        my-neovim-pkg = (nvf.lib.neovimConfiguration {
                                pkgs = nixpkgs.legacyPackages."${internalSystem}";
                                modules = [ ./nvf-configuration.nix ];
                        }).neovim;

                        gruvbox-plus-icons-git = pkgs.callPackage ./packages/gruvbox-plus-icons-git.nix {
                                inherit gruvbox-icons;
                        };

                        # Function to create a NixOS system configuration
                        mkHost = { hostname, extraModules ? [], system }: lib.nixosSystem {
                                inherit system;
                                modules =
                                        # Host-specific modules based on convention
                                        [
                                                ./hosts/${hostname}/configuration.nix
                                                ./hosts/${hostname}/hardware-configuration.nix
                                        ]
                                        ++
                                        # Common NixOS modules
                                        [
                                                nix-index-database.nixosModules.nix-index
                                                { programs.nix-index-database.comma.enable = true; }
                                                niri.nixosModules.niri
                                        ]
                                        ++
                                        # extraModules can be added in the function call
                                        extraModules;

                                specialArgs = {
                                        pkgs-stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
                                        inherit niri;
                                };
                        };

                        # Function to create a Home Manager configuration
                        mkHome = { username, hostname, extraModules ? [], system }: home-manager.lib.homeManagerConfiguration {
                                pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
                                modules =
                                        # Home-specific module based on convention
                                        [
                                                ./hosts/${hostname}/home.nix
                                        ]
                                        ++
                                        # Common Home Manager modules and packages
                                        [
                                                {
                                                        # These packages rely on the internalSystem build
                                                        home.packages = [
                                                                my-bash-scripts-pkg
                                                                my-neovim-pkg
                                                        ];
                                                }
                                                stylix.homeModules.stylix
                                                niri.homeModules.niri
                                        ]
                                        ++
                                        # extrModules can be added in the function call
                                        extraModules;

                                extraSpecialArgs = {
                                        inherit
                                        gruvbox-plus-icons-git
                                        niri
                                        zen-browser;
                                        pkgs-stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
                                };
                        };


                in {
                        defaultApp."${internalSystem}" = {
                                type = "app";
                                program = "${my-neovim-pkg}/bin/nvim";
                        };

                        nixosConfigurations = {
                                athena = mkHost {
                                        hostname = "athena";
                                        system = "x86_64-linux";
                                        extraModules = [
                                                asus-numberpad-driver.nixosModules.default
                                        ];
                                };

                                dionysus = mkHost {
                                        hostname = "dionysus";
                                        system = "x86_64-linux";
                                };
                        };

                        homeConfigurations = {
                                "mathijs@athena" = mkHome {
                                        username = "mathijs";
                                        hostname = "athena";
                                        system = "x86_64-linux";
                                };

                                "mathijs@dionysus" = mkHome {
                                        username = "mathijs";
                                        hostname = "dionysus";
                                        system = "x86_64-linux";
                                };
                        };
                };
}

