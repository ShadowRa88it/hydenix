{ inputs, system, nixpkgs, hydenix, ...}:
{
  nixosvm = (
    import ./nixosvm {
      inherit inputs system nixpkgs hydenix;
    }
  );
}