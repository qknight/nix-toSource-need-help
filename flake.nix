# generated from flake.nix.handlebars using cargo (manual edits won't be persistent)
{
  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-25.05";
  };
  outputs =
  { self, nixpkgs, flake-utils } @ inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [];
          };
          lib = pkgs.lib;

          project_root = ./.;

          cargoPackage = import ./nix/derivations/default.nix { inherit pkgs lib project_root; };
        in
        with pkgs;
        rec {
          packages = { inherit cargoPackage; };
          devShells.default = mkShell {
            buildInputs = [];
          };
        }
      );
}
