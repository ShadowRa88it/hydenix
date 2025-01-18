{ inputs, system, nixpkgs, hydenix, ...} @args:
let
  inherit (inputs.nixpkgs) lib;

  args = {
        inherit inputs system nixpkgs hydenix;
      };
  nixosvmSystems = {
    xps = (
      import ./xps (args)
    );
    nixosvm = (
      import ./nixosvm (args)
    );
    
  };

  allSystems = nixosvmSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosvmSystemValues =  builtins.attrValues nixosvmSystems;
  hydenixConfig = hydenix.lib.mkConfig {
    userConfig = import ./baseConfig.nix // import ./nixosvm/config.nix;
    # inputs without nixpkgs to prevent override
    extraInputs = removeAttrs inputs [ "nixpkgs" ];
  };
in {
  debugAttr = {inherit hydenixConfig nixosvmSystems allSystemNames nixosvmSystemValues;};
  #nixosvm = hydenixConfig.nixosConfiguration;
  # debugAttr = {inherit allSystems allSystemNames nixosvmSystemValues nixosvmSystems;};
  nixosConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) nixosvmSystemValues);
}
  # nixosvm = (
  #   import ./nixosvm {
  #     inherit inputs system nixpkgs hydenix;
  #   }
  # );

