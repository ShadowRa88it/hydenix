{ inputs, system, nixpkgs, hydenix, ...}:
let
  hydenixConfig = hydenix.lib.mkConfig {
    userConfig = import ../baseConfig.nix // import ./config.nix;
    # inputs without nixpkgs to prevent override
    extraInputs = removeAttrs inputs [ "nixpkgs" ];
  };
in
{
  nixosConfigurations.${hydenixConfig.userConfig.host} = hydenixConfig.nixosConfiguration;

  nixpkgs.overlays = [
    # Overlay 1: Use `self` and `super` to express
    # the inheritance relationship
    (self: super: {
      packages.${system} = super.packages.${system}.override {
        # Packages below load your config in ./config.nix

        # defaults to nix-vm - nix run .
        default = hydenixConfig.nix-vm.config.system.build.vm;

        # NixOS build packages - nix run .#hydenix / sudo nixos-rebuild switch/test --flake .#hydenix
        hydenix = hydenixConfig.nixosConfiguration.config.system.build.toplevel;

        # Home activation packages - nix run .#hm / nix run .#hm-generic / home-manager switch/test --flake .#hm or .#hm-generic
        hm = hydenixConfig.homeConfigurations.${hydenixConfig.userConfig.username}.activationPackage;
        hm-generic = hydenixConfig.homeConfigurations."${hydenixConfig.userConfig.username}-generic".activationPackage;

        # EXPERIMENTAL VM BUILDERS - nix run .#arch-vm / nix run .#fedora-vm
        arch-vm = hydenixConfig.arch-vm;
        fedora-vm = hydenixConfig.fedora-vm;
      };
    })
  ];
}