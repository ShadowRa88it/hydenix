{ inputs, hydenix, ...}:
{
  nixosvm = (
    import ./nixosvm {
      inherit inputs system hydenix;
    }
  );
}