{ inputs, ...}:
let
  system = "x86_64-linux";
in
{
  nixosvm = {
    import ./nixosvm {
      inherit inputs system;
    }
  };
}