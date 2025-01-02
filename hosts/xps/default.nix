{ inputs, nixpkgs, hydenix, ...}:
let
  hydenixConfig = hydenix.lib.mkConfig {
    userConfig = import ../baseConfig.nix // import ./config.nix;
    # inputs without nixpkgs to prevent override
    extraInputs = removeAttrs inputs [ "nixpkgs" ];
  };
in
{
  # {} = hydenixConfig.nixosConfiguration;
  #self.nixosConfigurations.nixosvm = hydenixConfig.nixosConfiguration;
  # Overlay 1: Use `self` and `super` to express
  # the inheritance relationship


}