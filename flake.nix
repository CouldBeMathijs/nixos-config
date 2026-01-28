{
  description = "The main flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

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
    microfetch-git = {
      url = "github:NotAShelf/microfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-bash-scripts-repo = {
      url = "github:CouldBeMathijs/bash-scripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    /*
      niri = {
        url = "github:sodiboo/niri-flake";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    */
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-25.11";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      flake-utils,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }:

    let
      # Hosts that actually run NixOS
      linuxSystems = [ "x86_64-linux" ];

      mkHost =
        {
          hostname,
          system,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix

            inputs.nix-index-database.nixosModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
            # inputs.niri.nixosModules.niri
          ]
          ++ extraModules;

          specialArgs = {
            pkgs-stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
            # inherit (inputs) niri;
          };
        };

      mkHome =
        {
          username,
          hostname,
          system,
          extraModules ? [ ],
        }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          modules = [
            ./hosts/${hostname}/home.nix

            {
              home.packages = [
                self.packages.${system}.my-bash-scripts
              ];
            }
            # inputs.niri.homeModules.niri
            inputs.plasma-manager.homeModules.plasma-manager

          ]
          ++ extraModules;

          extraSpecialArgs = {
            inherit (inputs) niri zen-browser;
            microfetch = inputs.microfetch-git.packages.${system};
            pkgs-stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
            gruvbox-plus-icons-git = self.packages.${system}.gruvbox-plus-icons-git;
            plasma-manager-pkgs = inputs.plasma-manager.packages.${system};
          };
        };

    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };

        gruvbox-plus-icons-git = pkgs.callPackage ./packages/gruvbox-plus-icons-git.nix {
          inherit (inputs) gruvbox-icons;
        };
      in
      {
        packages = {
          my-bash-scripts = inputs.my-bash-scripts-repo.packages.${system}.default;
          inherit gruvbox-plus-icons-git;
        };
      }
    )
    //

      {
        nixosConfigurations = {
          athena = mkHost {
            hostname = "athena";
            system = "x86_64-linux";
            extraModules = [
              inputs.asus-numberpad-driver.nixosModules.default
            ];
          };

          chronos = mkHost {
            hostname = "chronos";
            system = "x86_64-linux";
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

          "mathijs@chronos" = mkHome {
            username = "mathijs";
            hostname = "chronos";
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
