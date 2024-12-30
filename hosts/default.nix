{ inputs, system, nixpkgs, hydenix, ...}:
let
  hostname = builtins.getEnv "HOSTNAME";
  hydenixConfig = hydenix.lib.mkConfig {
    userConfig = import ./baseConfig.nix // import ./${hostname}/config.nix;
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