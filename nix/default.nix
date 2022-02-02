{ sources ? import ./sources.nix
}:
let
  # default nixpkgs
  pkgs = import sources."nixpkgs-haskell-updates" { system = "aarch64-linux"; };

  # gitignore.nix 
  gitignoreSource = (import sources."gitignore.nix" { inherit (pkgs) lib; }).gitignoreSource;

  pre-commit-hooks = (import sources."pre-commit-hooks.nix");

  haskellEnv = pkgs.haskellPackages.ghcWithPackages (ps: with ps;[ ]);

  src = gitignoreSource ./..;
in
{
  inherit pkgs src haskellEnv;

  # provided by shell.nix
  devTools = {
    inherit (pkgs) niv cabal-install;
    inherit haskellEnv;
    inherit (pre-commit-hooks) pre-commit;
  };

  # to be built by github actions
  ci = {
    pre-commit-check = pre-commit-hooks.run {
      inherit src;
      hooks = {
        shellcheck.enable = true;
        nixpkgs-fmt.enable = true;
        nix-linter.enable = true;
      };
      # generated files
      excludes = [ "^nix/sources\.nix$" ];
    };

    drv = pkgs.haskellPackages.callCabal2nix "" src { };
  };
}
