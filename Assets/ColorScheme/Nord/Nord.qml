import QtQuick

QtObject {
    property var dark: QtObject {
        readonly property color mPrimary: "#8fbcbb"
        readonly property color mOnPrimary: "#2e3440"
        readonly property color mSecondary: "#88c0d0"
        readonly property color mOnSecondary: "#2e3440"
        readonly property color mTertiary: "#5e81ac"
        readonly property color mOnTertiary: "#2e3440"
        readonly property color mError: "#bf616a"
        readonly property color mOnError: "#2e3440"
        readonly property color mSurface: "#2e3440"
        readonly property color mOnSurface: "#eceff4"
        readonly property color mSurfaceVariant: "#3b4252"
        readonly property color mOnSurfaceVariant: "#d8dee9"
        readonly property color mOutline: "#505a70"
        readonly property color mShadow: "#2e3440"
        readonly property color mHover: "#5e81ac"
        readonly property color mOnHover: "#2e3440"
    }
    property var light: QtObject {
        readonly property color mPrimary: "#5e81ac"
        readonly property color mOnPrimary: "#eceff4"
        readonly property color mSecondary: "#64adc2"
        readonly property color mOnSecondary: "#eceff4"
        readonly property color mTertiary: "#6fa9a8"
        readonly property color mOnTertiary: "#eceff4"
        readonly property color mError: "#bf616a"
        readonly property color mOnError: "#eceff4"
        readonly property color mSurface: "#eceff4"
        readonly property color mOnSurface: "#2e3440"
        readonly property color mSurfaceVariant: "#e5e9f0"
        readonly property color mOnSurfaceVariant: "#4c566a"
        readonly property color mOutline: "#c5cedd"
        readonly property color mShadow: "#d8dee9"
        readonly property color mHover: "#6fa9a8"
        readonly property color mOnHover: "#eceff4"
    }
}
