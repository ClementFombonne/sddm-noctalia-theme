{
  description = "Noctalia SDDM Theme";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    {
      nixosModules.default = import ./nix/nixos-module.nix;

      packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage (
        { stdenv, lib }:
        stdenv.mkDerivation {
          name = "noctalia-sddm-base";
          src = lib.cleanSource ./.;
          installPhase = ''
            mkdir -p "$out/share/sddm/themes/noctalia-sddm"
            cp -r Assets Commons Helpers Widgets Main.qml metadata.desktop qmldir \
              "$out/share/sddm/themes/noctalia-sddm"
          '';
        }
      ) { };
    };
}
