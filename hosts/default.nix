{ inputs, system, nixpkgs, hydenix, ...}:
let
  # inherit (inputs.nixpkgs) lib;
  nixosvmSystems = {
    nixosvm = (
      import ./nixosvm {
        inherit inputs system nixpkgs hydenix;
      }
    );
  };

  # allSystems = nixosvmSystems;
  # allSystemNames = builtins.attrNames allSystems;
  # nixosvmSystemValues =  builtins.attrValues nixosvmSystems;
  hydenixConfig = hydenix.lib.mkConfig {
    userConfig = import ./baseConfig.nix // import ./nixosvm/config.nix;
    # inputs without nixpkgs to prevent override
    extraInputs = removeAttrs inputs [ "nixpkgs" ];
  };
in {
  debugAttr = {inherit hydenixConfig nixosvmSystems;};
  nixosvm = hydenixConfig.nixosConfiguration;
  # debugAttr = {inherit allSystems allSystemNames nixosvmSystemValues nixosvmSystems;};
  # nixosConfigurations =
  #   lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) nixosvmSystemValues);
}
  # nixosvm = (
  #   import ./nixosvm {
  #     inherit inputs system nixpkgs hydenix;
  #   }
  # );

