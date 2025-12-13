pragma Singleton
import QtQuick

QtObject {
    id: root

    // --- 1. DEFAULT COLORS (Fallback) ---
    property color transparent: "transparent"
    property color black: "#000000"
    property color white: "#ffffff"

    property color mPrimary: "#c7a1d8"
    property color mOnPrimary: "#1a151f"

    property color mSecondary: "#a984c4"
    property color mOnSecondary: "#f3edf7"

    property color mTertiary: "#e0b7c9"
    property color mOnTertiary: "#20161f"

    property color mError: "#e9899d"
    property color mOnError: "#1e1418"

    property color mSurface: "#1c1822"
    property color mOnSurface: "#e9e4f0"

    property color mSurfaceVariant: "#262130"
    property color mOnSurfaceVariant: "#a79ab0"

    property color mOutline: "#342c42"
    property color mShadow: "#120f18"

    property color mHover: "#e0b7c9"
    property color mOnHover: "#20161f"

    // --- 2. DYNAMIC LOADING LOGIC ---

    // Configuration
    property string themeName: (config && config.colorScheme) ? config.colorScheme : "Noctalia-default"
    property bool isDarkMode: (config && config.darkMode) ? (config.darkMode === "true" || config.darkMode === true) : true

    // Internal storage for the loaded theme object
    property var _loadedTheme: null

    // Triggers
    onThemeNameChanged: loadColorScheme()
    onIsDarkModeChanged: applyColors() // Only re-apply, don't re-load file
    Component.onCompleted: loadColorScheme()

    function loadColorScheme() {
        var path = "../Assets/ColorScheme/" + themeName + "/" + themeName + ".qml";

        console.log("Loading Color Scheme QML from:", path);

        var component = Qt.createComponent(path);

        if (component.status === Component.Ready) {
            finishLoading(component);
        } else {
            component.statusChanged.connect(function () {
                if (component.status === Component.Ready) {
                    finishLoading(component);
                } else if (component.status === Component.Error) {
                    console.log("Error loading ColorScheme:", component.errorString());
                }
            });
        }
    }

    function finishLoading(component) {
        // Instantiate the theme object inside this QtObject
        _loadedTheme = component.createObject(root);

        if (_loadedTheme === null) {
            console.log("Error creating theme object.");
        } else {
            applyColors();
        }
    }

    function applyColors() {
        if (!_loadedTheme)
            return;

        var source = null;

        if (_loadedTheme.dark && _loadedTheme.light) {
            source = root.isDarkMode ? _loadedTheme.dark : _loadedTheme.light;
            console.log("Applying " + (root.isDarkMode ? "Dark" : "Light") + " mode.");
        } else {
            // Fallback for flat themes (no modes)
            source = _loadedTheme;
            console.log("Applying Flat theme (no mode detected).");
        }

        // Map values manually to ensure type safety
        // We use a safe helper to avoid crashes if a key is missing
        function set(key) {
            if (source[key] !== undefined) {
                root[key] = source[key];
            }
        }

        set("mPrimary");
        set("mOnPrimary");
        set("mSecondary");
        set("mOnSecondary");
        set("mTertiary");
        set("mOnTertiary");
        set("mError");
        set("mOnError");
        set("mSurface");
        set("mOnSurface");
        set("mSurfaceVariant");
        set("mOnSurfaceVariant");
        set("mOutline");
        set("mShadow");
        set("mHover");
        set("mOnHover");
    }
}
