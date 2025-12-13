import QtQuick

QtObject {
    property var dark: QtObject {
        readonly property color mPrimary: "#fff59b"
        readonly property color mOnPrimary: "#0e0e43"
        readonly property color mSecondary: "#a9aefe"
        readonly property color mOnSecondary: "#0e0e43"
        readonly property color mTertiary: "#9BFECE"
        readonly property color mOnTertiary: "#0e0e43"
        readonly property color mError: "#FD4663"
        readonly property color mOnError: "#0e0e43"
        readonly property color mSurface: "#070722"
        readonly property color mOnSurface: "#f3edf7"
        readonly property color mSurfaceVariant: "#11112d"
        readonly property color mOnSurfaceVariant: "#7c80b4"
        readonly property color mOutline: "#21215F"
        readonly property color mShadow: "#070722"
        readonly property color mHover: "#9BFECE"
        readonly property color mOnHover: "#0e0e43"
    }
    property var light: QtObject {
        readonly property color mPrimary: "#5d65f5"
        readonly property color mOnPrimary: "#dadcff"
        readonly property color mSecondary: "#8E93D8"
        readonly property color mOnSecondary: "#dadcff"
        readonly property color mTertiary: "#0e0e43"
        readonly property color mOnTertiary: "#fef29a"
        readonly property color mError: "#FD4663"
        readonly property color mOnError: "#0e0e43"
        readonly property color mSurface: "#e6e8fa"
        readonly property color mOnSurface: "#0e0e43"
        readonly property color mSurfaceVariant: "#eff0ff"
        readonly property color mOnSurfaceVariant: "#4b55c8"
        readonly property color mOutline: "#8288fc"
        readonly property color mShadow: "#f3edf7"
        readonly property color mHover: "#0e0e43"
        readonly property color mOnHover: "#fef29a"
    }
}
