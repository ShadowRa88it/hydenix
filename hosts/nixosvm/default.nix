{ inputs, self, system, ...}:
let
  hydenixConfig = hydenix.lib.mkConfig {
    userConfig = imports [../baseConfig.nix ./config.nix];
    # inputs without nixpkgs to prevent override
    extraInputs = removeAttrs inputs [ "nixpkgs" ];
  };
in
{
    self = hydenixConfig.nixosConfiguration;
}