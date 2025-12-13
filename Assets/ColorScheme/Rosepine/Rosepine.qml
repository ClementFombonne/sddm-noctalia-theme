import QtQuick

QtObject {
    property var dark: QtObject {
        readonly property color mPrimary: "#ebbcba"
        readonly property color mOnPrimary: "#191724"
        readonly property color mSecondary: "#9ccfd8"
        readonly property color mOnSecondary: "#191724"
        readonly property color mTertiary: "#31748f"
        readonly property color mOnTertiary: "#e0def4"
        readonly property color mError: "#eb6f92"
        readonly property color mOnError: "#191724"
        readonly property color mSurface: "#191724"
        readonly property color mOnSurface: "#e0def4"
        readonly property color mSurfaceVariant: "#26233a"
        readonly property color mOnSurfaceVariant: "#908caa"
        readonly property color mOutline: "#403d52"
        readonly property color mShadow: "#191724"
        readonly property color mHover: "#524f67"
        readonly property color mOnHover: "#e0def4"
    }
    property var light: QtObject {
        readonly property color mPrimary: "#d7827e"
        readonly property color mOnPrimary: "#faf4ed"
        readonly property color mSecondary: "#56949f"
        readonly property color mOnSecondary: "#faf4ed"
        readonly property color mTertiary: "#286983"
        readonly property color mOnTertiary: "#faf4ed"
        readonly property color mError: "#b4637a"
        readonly property color mOnError: "#faf4ed"
        readonly property color mSurface: "#fffaf3"
        readonly property color mOnSurface: "#575279"
        readonly property color mSurfaceVariant: "#f2e9e1"
        readonly property color mOnSurfaceVariant: "#797593"
        readonly property color mOutline: "#dfdad9"
        readonly property color mShadow: "#faf4ed"
        readonly property color mHover: "#cecacd"
        readonly property color mOnHover: "#575279"
    }
}
