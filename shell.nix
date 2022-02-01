{ project ? import ./nix { }
}:

project.pkgs.mkShell {
  buildInputs = builtins.attrValues project.devTools;
  shellHook = ''
    ${project.ci.pre-commit-check.shellHook}
    NIX_ENFORCE_PURITY=0 cabal --enable-nix new-build
  '';
}
