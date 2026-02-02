{ pkgs, lib ? pkgs.lib, project_root } :
let
  relativeFileset = root: relPaths: lib.fileset.unions (map (p: root + "/${p}") relPaths);
in
pkgs.stdenv.mkDerivation rec {
    name = "a_default_nix";
    phases = "unpackPhase installPhase";

############# these 3 all work ##############

    # src = builtins.filterSource
    #   (path: type:
    #     let base = baseNameOf path;
    #     in !(base == "target" || base == "result" || builtins.match "result-*" base != null)
    #   ) project_root;

    # src = lib.fileset.toSource {
    #   root = ../../.;
    #   fileset = lib.fileset.unions [
    #     ../../src/main.rs
    #     ../../src/build.rs
    #   ];
    # };

    src = lib.fileset.toSource rec {
      root = project_root;
      fileset = relativeFileset root [
        "src/main.rs"
        "src/build.rs"
      ];
    };

############# the only one which does not work but which should ##############
    
    # src = lib.fileset.toSource {
    #   root = project_root;
    #   fileset = lib.fileset.unions [
    #     src/main.rs
    #     src/build.rs
    #   ];
    # };

# strangely it works when putting this relative path hack in
    # src = lib.fileset.toSource {
    #   root = project_root;
    #   fileset = lib.fileset.unions [
    #     ../../src/main.rs
    #     ../../src/build.rs
    #   ];
    # };

installPhase = '' 
  mkdir $out
  cp -r * $out/
  du -a $out
  if [ -f $out/src/main.rs ]; then 
    echo -e "\033[0;32msuccess, the main.rs has been copied (qknight)\033[0m"; 
  else  
    echo -e "failed to copy the files"; 
    exit 101
  fi
'';
}
