{ inputs, system, nixpkgs, hydenix, ...}:
let
  hostname = builtins.getEnv "HOSTNAME";
  hydenixConfig = hydenix.lib.mkConfig {
    userConfig = import ./baseConfig.nix // import ./${hostname}/config.nix;
    # inputs without nixpkgs to prevent override
    extraInputs = removeAttrs inputs [ "nixpkgs" ];
  };
in{
  ${hostname} = hydenixConfig.nixosConfiguration;
  ${system} =  {
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
  # nixosvm = (
  #   import ./nixosvm {
  #     inherit inputs system nixpkgs hydenix;
  #   }
  # );

}