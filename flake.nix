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
      inherit (inputs.nixpkgs) lib;
      system = "x86_64-linux";
      nixosSystems = {
        hosts = import ./hosts {
          inherit inputs system nixpkgs hydenix;
        };
        # Move host defaults into flake output section. Or point flake to output file.
      };
      # hydenixConfig = hydenix.lib.mkConfig {
      #   userConfig = import ./config.nix;
      #   # nputs without nixpkgs to prevent override
      #   extraInputs = removeAttrs inputs [ "nixpkgs" ];
      # };
      nixosSystemNames = builtins.attrNames nixosSystems;
      nixosSystemValues = builtins.attrValues nixosSystems;

    in
    {
      debugAttrs = {inherit nixosSystems nixosSystemNames nixosSystemValues;};
      nixosConfigurations =
        lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) nixosSystemValues);
      #nixosConfigurations.${hydenixConfig.userConfig.host} = hydenixConfig.nixosConfiguration;
      # nixosConfigurations = (
      #   import ./hosts {
      #     inherit inputs system nixpkgs hydenix;
      #   }
      # );   

      packages = (
        import ./hosts/hydePackages.nix {
          inherit inputs system;
        }
      );   
    };
}
