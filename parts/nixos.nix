{ inputs, self, ... }:

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
      baseNixpkgs = if useStable then inputs.nixpkgs-stable else inputs.nixpkgs;
      hmModule =
        if useStable then
          inputs.home-manager-stable.nixosModules.home-manager
        else
          inputs.home-manager.nixosModules.home-manager;
    in
    baseNixpkgs.lib.nixosSystem {
      inherit system;
      pkgs = genPkgs baseNixpkgs system;

      # Pass things into configuration.nix
      specialArgs = {
        inherit inputs self;
        pkgs-unstable = genPkgs inputs.nixpkgs system;
        pkgs-stable = genPkgs inputs.nixpkgs-stable system;
      };

      modules = [
        ../hosts/${hostname}/configuration.nix
        ../hosts/${hostname}/hardware-configuration.nix

        hmModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Pass things into home.nix
          home-manager.extraSpecialArgs = {
            inherit (inputs) zen-browser;
            inherit self inputs;
            pkgs-unstable = genPkgs inputs.nixpkgs system;
            pkgs-stable = genPkgs inputs.nixpkgs-stable system;
            gruvbox-plus-icons-git = self.packages.${system}.gruvbox-plus-icons-git;
            plasma-manager-pkgs = inputs.plasma-manager.packages.${system};
          };

          home-manager.users.${username} = {
            imports = [
              ../hosts/${hostname}/home.nix
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
    };

in
{
  flake.nixosConfigurations = {
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
}
