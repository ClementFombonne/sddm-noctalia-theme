import QtQuick

QtObject {
    property var dark: QtObject {
        readonly property color mPrimary: "#76946a"
        readonly property color mOnPrimary: "#1f1f28"
        readonly property color mSecondary: "#c0a36e"
        readonly property color mOnSecondary: "#1f1f28"
        readonly property color mTertiary: "#7e9cd8"
        readonly property color mOnTertiary: "#1f1f28"
        readonly property color mError: "#c34043"
        readonly property color mOnError: "#1f1f28"
        readonly property color mSurface: "#1f1f28"
        readonly property color mOnSurface: "#c8c093"
        readonly property color mSurfaceVariant: "#2a2a37"
        readonly property color mOnSurfaceVariant: "#717c7c"
        readonly property color mOutline: "#363646"
        readonly property color mShadow: "#1f1f28"
        readonly property color mHover: "#7e9cd8"
        readonly property color mOnHover: "#1f1f28"
    }
    property var light: QtObject {
        readonly property color mPrimary: "#6f894e"
        readonly property color mOnPrimary: "#f2ecbc"
        readonly property color mSecondary: "#77713f"
        readonly property color mOnSecondary: "#f2ecbc"
        readonly property color mTertiary: "#4d699b"
        readonly property color mOnTertiary: "#f2ecbc"
        readonly property color mError: "#c84053"
        readonly property color mOnError: "#f2ecbc"
        readonly property color mSurface: "#f2ecbc"
        readonly property color mOnSurface: "#545464"
        readonly property color mSurfaceVariant: "#e5ddb0"
        readonly property color mOnSurfaceVariant: "#8a8980"
        readonly property color mOutline: "#cfc49c"
        readonly property color mShadow: "#f2ecbc"
        readonly property color mHover: "#4d699b"
        readonly property color mOnHover: "#f2ecbc"
    }
}
