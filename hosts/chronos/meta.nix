{ inputs, ... }:
{
  username = "mathijs";
  system = "x86_64-linux";
  extraModules = [ inputs.solaar.nixosModules.default ];
  useStable = false;
}
