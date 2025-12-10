import QtQuick
import QtQuick.Layouts

Text {
    id: root

    property string icon: ""
    property real pointSize: NStyle.fontSizeL
    property bool applyUiScale: true

    readonly property var iconMap: {
        "shutdown": "\u{eb0d}",
        "reboot": "\u{eb13}",
        "suspend": "\u{ed45}",
        "caret-down": "\u{fb2a}",
        "lock": "\u{eae2}",
        "eye": "\u{ea9a}",
        "user": "\u{eb4d}",
        "eye-off": "\u{ecf0}",
        "battery-charging": "\u{ea33}",
        "keyboard": "\u{ebd6}",
        "circle-filled": "\u{f671}",
        "alert-circle": "\u{ea05}",
        "arrow-forward": "\u{ea17}"
    }

    visible: (icon !== undefined) && (icon !== "")
    text: iconMap[icon] !== undefined ? iconMap[icon] : icon

    font.family: NStyle.fontName
    font.pointSize: applyUiScale ? root.pointSize * NStyle.uiScaleRatio : root.pointSize
    color: NColors.mOnSurface
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
}
