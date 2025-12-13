import QtQuick

QtObject {
    property var dark: QtObject {
        readonly property color mPrimary: "#b8bb26"
        readonly property color mOnPrimary: "#282828"
        readonly property color mSecondary: "#fabd2f"
        readonly property color mOnSecondary: "#282828"
        readonly property color mTertiary: "#83a598"
        readonly property color mOnTertiary: "#282828"
        readonly property color mError: "#fb4934"
        readonly property color mOnError: "#282828"
        readonly property color mSurface: "#282828"
        readonly property color mOnSurface: "#fbf1c7"
        readonly property color mSurfaceVariant: "#3c3836"
        readonly property color mOnSurfaceVariant: "#ebdbb2"
        readonly property color mOutline: "#57514e"
        readonly property color mShadow: "#282828"
        readonly property color mHover: "#83a598"
        readonly property color mOnHover: "#282828"
    }
    property var light: QtObject {
        readonly property color mPrimary: "#98971a"
        readonly property color mOnPrimary: "#fbf1c7"
        readonly property color mSecondary: "#d79921"
        readonly property color mOnSecondary: "#fbf1c7"
        readonly property color mTertiary: "#458588"
        readonly property color mOnTertiary: "#fbf1c7"
        readonly property color mError: "#cc241d"
        readonly property color mOnError: "#fbf1c7"
        readonly property color mSurface: "#fbf1c7"
        readonly property color mOnSurface: "#3c3836"
        readonly property color mSurfaceVariant: "#ebdbb2"
        readonly property color mOnSurfaceVariant: "#7c6f64"
        readonly property color mOutline: "#bdae93"
        readonly property color mShadow: "#d5c4a1"
        readonly property color mHover: "#458588"
        readonly property color mOnHover: "#fbf1c7"
    }
}
