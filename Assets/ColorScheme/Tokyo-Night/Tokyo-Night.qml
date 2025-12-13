import QtQuick

QtObject {
    property var dark: QtObject {
        readonly property color mPrimary: "#7aa2f7"
        readonly property color mOnPrimary: "#16161e"
        readonly property color mSecondary: "#bb9af7"
        readonly property color mOnSecondary: "#16161e"
        readonly property color mTertiary: "#9ece6a"
        readonly property color mOnTertiary: "#16161e"
        readonly property color mError: "#f7768e"
        readonly property color mOnError: "#16161e"
        readonly property color mSurface: "#1a1b26"
        readonly property color mOnSurface: "#c0caf5"
        readonly property color mSurfaceVariant: "#24283b"
        readonly property color mOnSurfaceVariant: "#9aa5ce"
        readonly property color mOutline: "#353D57"
        readonly property color mShadow: "#15161e"
        readonly property color mHover: "#9ece6a"
        readonly property color mOnHover: "#16161e"
    }
    property var light: QtObject {
        readonly property color mPrimary: "#2e7de9"
        readonly property color mOnPrimary: "#e1e2e7"
        readonly property color mSecondary: "#9854f1"
        readonly property color mOnSecondary: "#e1e2e7"
        readonly property color mTertiary: "#587539"
        readonly property color mOnTertiary: "#e1e2e7"
        readonly property color mError: "#f52a65"
        readonly property color mOnError: "#e1e2e7"
        readonly property color mSurface: "#e1e2e7"
        readonly property color mOnSurface: "#3760bf"
        readonly property color mSurfaceVariant: "#d0d5e3"
        readonly property color mOnSurfaceVariant: "#6172b0"
        readonly property color mOutline: "#b4b5b9"
        readonly property color mShadow: "#a8aecb"
        readonly property color mHover: "#587539"
        readonly property color mOnHover: "#e1e2e7"
    }
}
