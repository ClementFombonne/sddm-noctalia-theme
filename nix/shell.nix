{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
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
    qt6.qtquick3d
  ];

  # 2. Automatically Setup Environment Variables
  nativeBuildInputs = [
    pkgs.qt6.wrapQtAppsHook
  ];

  # 3. Explicitly export variables for the editor
  shellHook = ''
    export QML_IMPORT_PATH="${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:${pkgs.qt6.qtquick3d}/lib/qt-6/qml"
    export QT_PLUGIN_PATH="${pkgs.qt6.qtbase}/lib/qt-6/plugins"

    echo "🚀 QML Environment Loaded"
    echo "QML_IMPORT_PATH is set to: $QML_IMPORT_PATH"
  '';
}
