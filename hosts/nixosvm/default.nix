{ inputs, system, nixpkgs, hydenix, ...}:
let
  hydenixConfig = hydenix.lib.mkConfig {
    userConfig = import ../baseConfig.nix // import ./config.nix;
    # inputs without nixpkgs to prevent override
    extraInputs = removeAttrs inputs [ "nixpkgs" ];
  };
in
{
  nixosConfigurations = {
    "nixosvm" = hydenixConfig.nixosConfiguration;
  };
  # {} = hydenixConfig.nixosConfiguration;
  #self.nixosConfigurations.nixosvm = hydenixConfig.nixosConfiguration;
  # Overlay 1: Use `self` and `super` to express
  # the inheritance relationship


}