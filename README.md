# Motivation

This repo helps to understand calling the generated build system from cargo (libnix) backend from

1. a flake.nix
2. cargo_build_caller.nix (which is used from the cargo (libnix) binary to trigger the nix build)

The main goal is to be able to separate the build system from the source code location as 
a dev might move the project files to a different directory and thus we should not use absolute
paths. It should also be possible to point to a remote URL and use that source code instead of
a local copy.

# Build start

You can evaluate this with:

1. `nix build .#cargoPackage`

2. `nix build --file cargo_build_caller.nix -L --arg project_root '/home/nixos/nix-toSource-need-help'`

Both will display "success, the main..." when it works and error 101 if it does not. But most likely
**lib.fileset.unions** will error out first.

Success:

    a_default_nix> success, the main.rs has been copied (qknight)

Error:

     error: lib.fileset.unions: Element 0 (/home/nixos/nix-toSource-need-help/nix/derivations/src/main.rs) is a path that does not exist.
           To create a file set from a path that may not exist, use `lib.fileset.maybeMissing`.

# Question

In the [nix/derivations/default.nix](https://github.com/qknight/nix-toSource-need-help/blob/master/nix/derivations/default.nix) there are several **src=** blocks:

* Some use fixed paths to show that evaluation in principle works with fixed paths.
* Some use `relativeFileset` as a hack to make toSource work with a dynamic `project_root` argument.
* And then there is the naive attempt to use `toSource` with `project_root` without the `relativeFileset` hack, which fails...

Now the main question here is:

Can we add a variant of `lib.fileset.toSource` (like `lib.fileset.toSourceRelative`) which:

* sees `root` as a baseDir and 
* `fileset = lib.fileset.unions [` as a list of files relative to baseDir

Contrast: `toSource` sees `root` as a prefix which needs to be removed from all the entries in the given `fileset`.

```nix
project_root = /home/foo/myproject;
src = lib.fileset.toSourceRelative {
    root = project_root;
    fileset = lib.fileset.unions [
        src/main.rs
        src/build.rs
    ];
};
```