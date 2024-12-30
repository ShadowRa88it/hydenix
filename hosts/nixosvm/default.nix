{ inputs, system, nixpkgs, hydenix, ...}:
let
  hydenixConfig = hydenix.lib.mkConfig {
    userConfig = import ../baseConfig.nix ++ import ./config.nix;
    # inputs without nixpkgs to prevent override
    extraInputs = removeAttrs inputs [ "nixpkgs" ];
  };
in
{
    self = hydenixConfig.nixosConfiguration;
}