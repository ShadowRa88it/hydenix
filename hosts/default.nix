{ inputs, hydenix, system, ...}:
{
  nixosvm = (
    import ./nixosvm {
      inherit inputs hydenix system;
    }
  );
}