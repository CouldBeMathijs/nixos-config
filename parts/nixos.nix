{ inputs, self, ... }:

let
  lib = inputs.nixpkgs.lib;

  genPkgs =
    pkgsSource: system:
    import pkgsSource {
      inherit system;
      config.allowUnfree = true;
    };

  # mkHost now takes a single argument: the hostname
  mkHost =
    hostname:
    let
      # Import the host-specific metadata
      meta = import ../hosts/${hostname}/meta.nix { inherit inputs; };

      system = meta.system or "x86_64-linux";
      username = meta.username;
      useStable = meta.useStable or false;
      extraModules = meta.extraModules or [ ];

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

      specialArgs = {
        inherit inputs self hostname;
        pkgs-unstable = genPkgs inputs.nixpkgs system;
        pkgs-stable = genPkgs inputs.nixpkgs-stable system;
      };

      modules = [
        ../modules/nixos/common.nix
        ../hosts/${hostname}/configuration.nix
        ../hosts/${hostname}/hardware-configuration.nix

        hmModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

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

  hostsDir = ../hosts;
  hostNames = lib.attrNames (
    lib.filterAttrs (name: type: type == "directory") (builtins.readDir hostsDir)
  );

in
{
  # lib.genAttrs automatically creates an attribute set like { athena = mkHost "athena"; ... }
  flake.nixosConfigurations = lib.genAttrs hostNames mkHost;
}
