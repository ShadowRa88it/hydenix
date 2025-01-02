{
  description = "template for hydenix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hydenix = {
      # Available inputs:
      # Main: github:richen604/hydenix
      # Dev: github:richen604/hydenix/dev 
      # Commit: github:richen604/hydenix/<commit-hash>
      # Version: github:richen604/hydenix/v1.0.0
      url = "github:richen604/hydenix";
    };
  };

  outputs =
    {
      self,
      hydenix,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      nixosSystems = {
        x86_64-linux = import ./hosts {inherit inputs system nixpkgs hydenix};
      };
      
      allSystems = nixosSystems;
      allSystemNames = builtins.attrNames allSystems;
      nixosSystemValues = builtins.attrValues nixosSystems;
      allSystemValues = nixosSystemValues;
      # hydenixConfig = hydenix.lib.mkConfig {
      #   userConfig = import ./config.nix;
      #   # inputs without nixpkgs to prevent override
      #   extraInputs = removeAttrs inputs [ "nixpkgs" ];
      # };
      # Helper function to generate a set of attributes for each system
      forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);
    in
    {

      #nixosConfigurations.${hydenixConfig.userConfig.host} = hydenixConfig.nixosConfiguration;
      nixosConfigurations = lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) systemValues);   

      packages =  forAllSystems (
        system: allSystems.${system}.packages or {}
      );
    };
}
