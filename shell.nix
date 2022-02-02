{ project ? import ./nix { }
}:
let
  drv = project.pkgs.haskellPackages.callCabal2nix "" src { };

in
project.pkgs.haskellPackages.shellFor {
  packages = _: [ drv ];
  buildInputs = builtins.attrValues project.devTools;
  shellHook = ''
    ${project.ci.pre-commit-check.shellHook}
    ghc -e 'putStrLn ("Architecture: " ++ System.Info.arch)'
    NIX_ENFORCE_PURITY=0 cabal --enable-nix new-build --constraint 'lukko -ofd-locking' 
  '';
}
