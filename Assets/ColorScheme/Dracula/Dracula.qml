import QtQuick

QtObject {
    property var dark: QtObject {
        readonly property color mPrimary: "#bd93f9"
        readonly property color mOnPrimary: "#282A36"
        readonly property color mSecondary: "#ff79c6"
        readonly property color mOnSecondary: "#4e1d32"
        readonly property color mTertiary: "#8be9fd"
        readonly property color mOnTertiary: "#003543"
        readonly property color mError: "#FF5555"
        readonly property color mOnError: "#282A36"
        readonly property color mSurface: "#282A36"
        readonly property color mOnSurface: "#F8F8F2"
        readonly property color mSurfaceVariant: "#44475A"
        readonly property color mOnSurfaceVariant: "#d6d8e0"
        readonly property color mOutline: "#5a5e77"
        readonly property color mShadow: "#282A36"
        readonly property color mHover: "#8be9fd"
        readonly property color mOnHover: "#003543"
    }
    property var light: QtObject {
        readonly property color mPrimary: "#8332f4"
        readonly property color mOnPrimary: "#ffffff"
        readonly property color mSecondary: "#ff1399"
        readonly property color mOnSecondary: "#ffffff"
        readonly property color mTertiary: "#0398b9"
        readonly property color mOnTertiary: "#ffffff"
        readonly property color mError: "#FF5555"
        readonly property color mOnError: "#282A36"
        readonly property color mSurface: "#f8f8f2"
        readonly property color mOnSurface: "#282a36"
        readonly property color mSurfaceVariant: "#e6e6ea"
        readonly property color mOnSurfaceVariant: "#44475a"
        readonly property color mOutline: "#cacad3"
        readonly property color mShadow: "#d6d8e0"
        readonly property color mHover: "#0398b9"
        readonly property color mOnHover: "#ffffff"
    }
}
