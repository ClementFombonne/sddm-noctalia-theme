import QtQuick

QtObject {
    property var dark: QtObject {
        readonly property color mPrimary: "#E6B450"
        readonly property color mOnPrimary: "#0B0E14"
        readonly property color mSecondary: "#AAD94C"
        readonly property color mOnSecondary: "#0B0E14"
        readonly property color mTertiary: "#39BAE6"
        readonly property color mOnTertiary: "#0B0E14"
        readonly property color mError: "#D95757"
        readonly property color mOnError: "#0B0E14"
        readonly property color mSurface: "#0B0E14"
        readonly property color mOnSurface: "#BFBDB6"
        readonly property color mSurfaceVariant: "#1e222a"
        readonly property color mOnSurfaceVariant: "#636A72"
        readonly property color mOutline: "#565B66"
        readonly property color mShadow: "#000000"
        readonly property color mHover: "#39BAE6"
        readonly property color mOnHover: "#0B0E14"
    }
    property var light: QtObject {
        readonly property color mPrimary: "#FF8F40"
        readonly property color mOnPrimary: "#F8F9FA"
        readonly property color mSecondary: "#86B300"
        readonly property color mOnSecondary: "#F8F9FA"
        readonly property color mTertiary: "#55B4D4"
        readonly property color mOnTertiary: "#F8F9FA"
        readonly property color mError: "#E65050"
        readonly property color mOnError: "#F8F9FA"
        readonly property color mSurface: "#F8F9FA"
        readonly property color mOnSurface: "#5C6166"
        readonly property color mSurfaceVariant: "#E4E6E9"
        readonly property color mOnSurfaceVariant: "#8A9199"
        readonly property color mOutline: "#8A9199"
        readonly property color mShadow: "#F8F9FA"
        readonly property color mHover: "#55B4D4"
        readonly property color mOnHover: "#F8F9FA"
    }
}
