pragma Singleton

import QtQuick

QtObject {
    id: root
    readonly property color mPrimary: "#cba6f7"
    readonly property color mOnPrimary: "#11111b"
    readonly property color mSecondary: "#fab387"
    readonly property color mOnSecondary: "#11111b"
    readonly property color mTertiary: "#94e2d5"
    readonly property color mOnTertiary: "#11111b"

    // --- Utility Colors: These colors serve specific, universal purposes like indicating errors
    readonly property color mError: "#f38ba8"
    readonly property color mOnError: "#11111b"

    // --- Surface and Variant Colors: These provide additional options for surfaces and their contents, creating visual hierarchy
    readonly property color mSurface: "#1e1e2e"
    readonly property color mOnSurface: "#cdd6f4"
    readonly property color mSurfaceVariant: "#313244"
    readonly property color mOnSurfaceVariant: "#a3b4eb"
    readonly property color mOutline: "#4c4f69"
    readonly property color mShadow: "#11111b"
    readonly property color mHover: "#94e2d5"
    readonly property color mOnHover: "#11111b"

    // --- Absolute Colors
    readonly property color transparent: "transparent"
    readonly property color black: "#000000"
    readonly property color white: "#ffffff"
}
