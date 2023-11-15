{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, array, base, lib, mtl, unix }:
      mkDerivation {
        pname = "brainfuck";
        version = "0.1.0.3";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [ array base mtl ];
        executableHaskellDepends = [ array base mtl unix ];
        description = "Brainfuck interpreter";
        license = "GPL";
        mainProgram = "bf";
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
