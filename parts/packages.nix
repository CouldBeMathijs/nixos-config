
{ inputs, ... }:

{
  perSystem = { pkgs, system, ... }: {
    packages = {
      my-bash-scripts = inputs.my-bash-scripts-repo.packages.${system}.default.override {
        withWayland = true;
        withX11 = false;
      };

      gruvbox-plus-icons-git = pkgs.callPackage ../packages/gruvbox-plus-icons-git.nix {
        inherit (inputs) gruvbox-icons;
      };
    };
  };
}
