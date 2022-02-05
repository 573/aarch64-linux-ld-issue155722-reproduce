{ project ? import ./nix { }
}:
project.pkgs.haskellPackages.shellFor {
  packages = _: [ project.drv ];
  buildInputs = builtins.attrValues project.devTools;
  shellHook = ''
    ${project.ci.pre-commit-check.shellHook}
    ghc -e 'putStrLn ("Architecture: " ++ System.Info.arch)'
    NIX_ENFORCE_PURITY=0 cabal new-build 
  '';
}
