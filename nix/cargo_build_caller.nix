# generated from cargo_build_caller.nix.handlebars using cargo (manual edits won't be persistent)
{ system ? builtins.currentSystem, project_root ? ../. }:
let
  nixpkgsSrc = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/25.05.tar.gz";
    sha256 = "sha256:1915r28xc4znrh2vf4rrjnxldw2imysz819gzhk9qlrkqanmfsxd";
  };
  pkgs = import (nixpkgsSrc + "/pkgs/top-level/default.nix") {
    localSystem = { inherit system; };
  };
  cargoPackage = import ./derivations/default.nix {
    inherit pkgs;
    inherit project_root;
  };
in
cargoPackage
