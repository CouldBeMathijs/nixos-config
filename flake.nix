{
  description = "CouldBeMathijs's main system flake";

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

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    gruvbox-icons = {
      url = "github:SylEleuth/gruvbox-plus-icon-pack/master";
      flake = false;
    };

    my-bash-scripts-repo = {
      url = "github:CouldBeMathijs/bash-scripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

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
          username,
          system,
          useStable ? false,
          extraModules ? [ ],
        }:
        let
          baseNixpkgs = if useStable then nixpkgs-stable else nixpkgs;
          hmModule =
            if useStable then
              home-manager-stable.nixosModules.home-manager
            else
              home-manager.nixosModules.home-manager;
        in
        baseNixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = genPkgs baseNixpkgs system;
          modules = [
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix

            hmModule
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # home-manager.backupFileExtension = "backup";

              home-manager.extraSpecialArgs = {
                inherit (inputs) zen-browser;
                pkgs-unstable = genPkgs nixpkgs system;
                pkgs-stable = genPkgs nixpkgs-stable system;
                gruvbox-plus-icons-git = self.packages.${system}.gruvbox-plus-icons-git;
                plasma-manager-pkgs = inputs.plasma-manager.packages.${system};
              };

              home-manager.users.${username} = {
                imports = [
                  ./hosts/${hostname}/home.nix
                  inputs.plasma-manager.homeModules.plasma-manager
                ];
                home = {
                  inherit username;
                  homeDirectory = "/home/${username}";
                  packages = [ self.packages.${system}.my-bash-scripts ];
                };
              };
            }

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

    in
    flake-utils.lib.eachDefaultSystem (system: {
      packages = {
        my-bash-scripts = inputs.my-bash-scripts-repo.packages.${system}.default.override {
          withWayland = true;
          withX11 = false;
        };
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
          username = "mathijs";
          system = "x86_64-linux";
          useStable = false;
          extraModules = [ inputs.asus-numberpad-driver.nixosModules.default ];
        };
        chronos = mkHost {
          hostname = "chronos";
          username = "mathijs";
          system = "x86_64-linux";
          useStable = false;
        };
        dionysus = mkHost {
          hostname = "dionysus";
          username = "mathijs";
          system = "x86_64-linux";
          useStable = false;
        };
        zeus = mkHost {
          hostname = "zeus";
          username = "zeus";
          system = "x86_64-linux";
          useStable = true;
        };
      };
    };
}
