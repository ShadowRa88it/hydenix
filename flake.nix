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
      hydenix,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # hydenixConfig = hydenix.lib.mkConfig {
      #   userConfig = import ./config.nix;
      #   # inputs without nixpkgs to prevent override
      #   extraInputs = removeAttrs inputs [ "nixpkgs" ];
      # };
    in
    {

      #nixosConfigurations.${hydenixConfig.userConfig.host} = hydenixConfig.nixosConfiguration;
      nixosConfigurations = (
        import ./hosts {
          inherit inputs system nixpkgs hydenix;
        }
      );      
    };
}
