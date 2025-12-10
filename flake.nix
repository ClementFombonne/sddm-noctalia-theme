{
  description = "QML Development Environment with working LSP";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Change to aarch64-darwin for Mac, etc.
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        # 1. Packages available in the shell
        packages = with pkgs; [
          # Build tools
          cmake
          ninja
          pkg-config

          # Qt6 full suite (includes qmlls, qmlformat)
          qt6.qtbase
          qt6.qtdeclarative
          qt6.qt5compat
          qt6.qttools
          qt6.qtquick3d # Add other Qt modules as needed
        ];

        # 2. Automatically Setup Environment Variables
        # This hook automatically calculates QML_IMPORT_PATH and QT_PLUGIN_PATH
        # based on the inputs listed above.
        nativeBuildInputs = [
          pkgs.qt6.wrapQtAppsHook
        ];

        # 3. Explicitly export variables for the editor
        # While the hook helps apps run, we sometimes need to explicitly
        # export these so Neovim/qmlls inherits them.
        shellHook = ''
          export QML_IMPORT_PATH="${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:${pkgs.qt6.qtquick3d}/lib/qt-6/qml"
          export QT_PLUGIN_PATH="${pkgs.qt6.qtbase}/lib/qt-6/plugins"

          echo "🚀 QML Environment Loaded"
          echo "QML_IMPORT_PATH is set to: $QML_IMPORT_PATH"
        '';
      };
    };
}
