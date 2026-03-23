{ inputs, ... }:
{
  username = "mathijs";
  system = "x86_64-linux";
  useStable = false;
  extraModules = [ inputs.asus-numberpad-driver.nixosModules.default ];
}
