import QtQuick

QtObject {
    property var dark: QtObject {
        readonly property color mPrimary: "#cba6f7"
        readonly property color mOnPrimary: "#11111b"
        readonly property color mSecondary: "#fab387"
        readonly property color mOnSecondary: "#11111b"
        readonly property color mTertiary: "#94e2d5"
        readonly property color mOnTertiary: "#11111b"
        readonly property color mError: "#f38ba8"
        readonly property color mOnError: "#11111b"
        readonly property color mSurface: "#1e1e2e"
        readonly property color mOnSurface: "#cdd6f4"
        readonly property color mSurfaceVariant: "#313244"
        readonly property color mOnSurfaceVariant: "#a3b4eb"
        readonly property color mOutline: "#4c4f69"
        readonly property color mShadow: "#11111b"
        readonly property color mHover: "#94e2d5"
        readonly property color mOnHover: "#11111b"
    }
    property var light: QtObject {
        readonly property color mPrimary: "#8839ef"
        readonly property color mOnPrimary: "#eff1f5"
        readonly property color mSecondary: "#fe640b"
        readonly property color mOnSecondary: "#eff1f5"
        readonly property color mTertiary: "#40a02b"
        readonly property color mOnTertiary: "#eff1f5"
        readonly property color mError: "#d20f39"
        readonly property color mOnError: "#dce0e8"
        readonly property color mSurface: "#eff1f5"
        readonly property color mOnSurface: "#4c4f69"
        readonly property color mSurfaceVariant: "#ccd0da"
        readonly property color mOnSurfaceVariant: "#6c6f85"
        readonly property color mOutline: "#a5adcb"
        readonly property color mShadow: "#dce0e8"
        readonly property color mHover: "#40a02b"
        readonly property color mOnHover: "#eff1f5"
    }
}
