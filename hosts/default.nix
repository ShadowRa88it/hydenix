{ inputs, system, nixpkgs, hydenix, ...}:
let
  hydenixConfig = hydenix.lib.mkConfig {
    userConfig = import ./baseConfig.nix // import ./nixosvm/config.nix;
    # inputs without nixpkgs to prevent override
    extraInputs = removeAttrs inputs [ "nixpkgs" ];
  };
in{
  nixosvm = hydenixConfig.nixosConfiguration;
  # nixosvm = (
  #   import ./nixosvm {
  #     inherit inputs system nixpkgs hydenix;
  #   }
  # );

}