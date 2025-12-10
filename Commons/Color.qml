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
}
