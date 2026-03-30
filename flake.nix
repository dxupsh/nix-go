{
  description = "Pinned Go toolchain, independent of nixpkgs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          goPackage = pkgs.callPackage ./go.nix {};
          buildGoModule = pkgs.buildGoModule.override { go = goPackage; };
        in {
          default = goPackage;
          deadcode = pkgs.callPackage ./tools/deadcode.nix { inherit buildGoModule; };
        }
      );
    };
}
