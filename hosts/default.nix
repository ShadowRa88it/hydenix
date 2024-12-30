{ inputs, system, nixpkgs, hydenix, ...}:
{
  # nixosvm = hydenixConfig.nixosConfiguration;
  nixosvm = (
    import ./nixosvm {
      inherit inputs system nixpkgs hydenix;
    }
  );

  
  
}