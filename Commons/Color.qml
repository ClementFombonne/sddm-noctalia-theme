pragma Singleton
import QtQuick

QtObject {
    id: root
    property color mPrimary: "#cba6f7"
    property color mOnPrimary: "#11111b"
    property color mSecondary: "#fab387"
    property color mOnSecondary: "#11111b"
    property color mTertiary: "#94e2d5"
    property color mOnTertiary: "#11111b"

    // --- Utility Colors ---
    property color mError: "#f38ba8"
    property color mOnError: "#11111b"

    // --- Surface and Variant Colors ---
    property color mSurface: "#1e1e2e"
    property color mOnSurface: "#cdd6f4"
    property color mSurfaceVariant: "#313244"
    property color mOnSurfaceVariant: "#a3b4eb"
    property color mOutline: "#4c4f69"
    property color mShadow: "#11111b"
    property color mHover: "#94e2d5"
    property color mOnHover: "#11111b"

    // --- Absolute Colors ---
    readonly property color transparent: "transparent"
    readonly property color black: "#000000"
    readonly property color white: "#ffffff"

    property string themeName: config.colorSchemeValue || "Noctalia-default"
    property bool isDarkMode: config.darkMode === "true" || config.darkMode === true

    onThemeNameChanged: loadColorScheme()
    onIsDarkModeChanged: loadColorScheme()
    Component.onCompleted: loadColorScheme()

    function loadColorScheme() {
        // Construct path: Assets/ColorScheme/<name>/<name>.json
        // Note: QML file reads usually require "file://" prefix or relative path handling.
        // Since this is a singleton in /commons, we go up one level to root, then into assets.
        var path = "../Assets/ColorScheme/" + themeName + "/" + themeName + ".json";

        console.log("Loading Color Scheme from:", path);

        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || xhr.status === 0) {
                    try {
                        var json = JSON.parse(xhr.responseText);
                        applyColors(json);
                    } catch (e) {
                        console.log("Error parsing ColorScheme JSON:", e);
                    }
                } else {
                    console.log("Failed to load ColorScheme file. Status:", xhr.status);
                }
            }
        };
        xhr.open("GET", path);
        xhr.send();
    }

    function applyColors(data) {
        var colorsToApply = {};

        // 1. Check for Dark/Light keys
        if (data["dark"] !== undefined && data["light"] !== undefined) {
            if (root.isDarkMode) {
                console.log("Applying DARK mode colors");
                colorsToApply = data["dark"];
            } else {
                console.log("Applying LIGHT mode colors");
                colorsToApply = data["light"];
            }
        } else
        // 2. Handle flat structure (no mode support)
        {
            console.log("Applying FLAT color scheme (no dark/light mode found)");
            colorsToApply = data;
        }

        // 3. Map values to properties
        // We iterate over the known properties to ensure safety
        var keys = ["mPrimary", "mOnPrimary", "mSecondary", "mOnSecondary", "mTertiary", "mOnTertiary", "mError", "mOnError", "mSurface", "mOnSurface", "mSurfaceVariant", "mOnSurfaceVariant", "mOutline", "mShadow", "mHover", "mOnHover"];

        for (var i = 0; i < keys.length; i++) {
            var key = keys[i];
            if (colorsToApply[key]) {
                root[key] = colorsToApply[key];
            }
        }
    }
}
