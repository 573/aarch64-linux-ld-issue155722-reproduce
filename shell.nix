{ project ? import ./nix { }
}:

project.pkgs.mkShell {
  buildInputs = builtins.attrValues project.devTools;
  shellHook = ''
    ${project.ci.pre-commit-check.shellHook}
    ghc -e 'putStrLn ("Architecture: " ++ System.Info.arch)'
    NIX_ENFORCE_PURITY=0 cabal --enable-nix new-build --constraint 'lukko -ofd-locking' 
  '';
}
