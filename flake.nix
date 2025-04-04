{
  description = "Go development environment using Nix flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs { 
        system = "x86_64-linux";
      };
      goPackage = pkgs.go;

    in {
      # Default system for a Go dev shell
      devShell.x86_64-linux = with pkgs; mkShell rec {
        buildInputs = [
          goPackage
          gopls
          git
          go-tools  # Go-related development tools like `golint`, `gofmt`, `goimports`
        ];

        shellHook = ''
          export GOPATH=${toString ./go}
          export GOROOT=${goPackage}/share/go
          export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
        '';
      };
    };
}
