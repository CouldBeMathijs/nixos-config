{
  description = "The main flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    asus-numberpad-driver = {
      url = "github:asus-linux-drivers/asus-numberpad-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unstable branch (Master)
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stable branch (Match your Nixpkgs version)
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
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
      home-manager-stable,
      ...
    }:
    let
      genPkgs =
        pkgsSource: system:
        import pkgsSource {
          inherit system;
          config.allowUnfree = true;
        };

      mkHost =
        {
          hostname,
          system,
          useStable ? false,
          extraModules ? [ ],
        }:
        let
          baseNixpkgs = if useStable then nixpkgs-stable else nixpkgs;
        in
        baseNixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = genPkgs baseNixpkgs system;
          modules = [
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix
            inputs.nix-index-database.nixosModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
          ]
          ++ extraModules;
          specialArgs = {
            inherit inputs;
            pkgs-unstable = genPkgs nixpkgs system;
            pkgs-stable = genPkgs nixpkgs-stable system;
          };
        };

      mkHome =
        {
          username,
          hostname,
          system,
          useStable ? false,
          extraModules ? [ ],
        }:
        let
          # --- AUTOMATIC VERSION SELECTION ---
          # Pick the correct Home Manager library
          hmLib = if useStable then home-manager-stable.lib else home-manager.lib;
          # Pick the correct base Nixpkgs
          baseNixpkgs = if useStable then nixpkgs-stable else nixpkgs;
        in
        hmLib.homeManagerConfiguration {
          pkgs = genPkgs baseNixpkgs system;
          modules = [
            ./hosts/${hostname}/home.nix
            {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
                # Auto-align stateVersion to the branch
                stateVersion = if useStable then "25.11" else "26.05";
                packages = [ self.packages.${system}.my-bash-scripts ];
              };
            }
            inputs.plasma-manager.homeModules.plasma-manager
          ]
          ++ extraModules;

          extraSpecialArgs = {
            inherit (inputs) niri zen-browser;
            microfetch = inputs.microfetch-git.packages.${system};
            pkgs-unstable = genPkgs nixpkgs system;
            pkgs-stable = genPkgs nixpkgs-stable system;
            gruvbox-plus-icons-git = self.packages.${system}.gruvbox-plus-icons-git;
            plasma-manager-pkgs = inputs.plasma-manager.packages.${system};
          };
        };

    in
    flake-utils.lib.eachDefaultSystem (system: {
      packages = {
        my-bash-scripts = inputs.my-bash-scripts-repo.packages.${system}.default;
        gruvbox-plus-icons-git =
          (genPkgs nixpkgs system).callPackage ./packages/gruvbox-plus-icons-git.nix
            {
              inherit (inputs) gruvbox-icons;
            };
      };
    })
    // {
      nixosConfigurations = {
        athena = mkHost {
          hostname = "athena";
          system = "x86_64-linux";
          useStable = false;
          extraModules = [ inputs.asus-numberpad-driver.nixosModules.default ];
        };
        chronos = mkHost {
          hostname = "chronos";
          system = "x86_64-linux";
          useStable = false;
        };
        dionysus = mkHost {
          hostname = "dionysus";
          system = "x86_64-linux";
          useStable = false;
        };
      };

      homeConfigurations = {
        "mathijs@athena" = mkHome {
          username = "mathijs";
          hostname = "athena";
          system = "x86_64-linux";
          useStable = false;
        };
        "mathijs@chronos" = mkHome {
          username = "mathijs";
          hostname = "chronos";
          system = "x86_64-linux";
          useStable = false;
        };
        "mathijs@dionysus" = mkHome {
          username = "mathijs";
          hostname = "dionysus";
          system = "x86_64-linux";
          useStable = false;
        };
      };
    };
}
