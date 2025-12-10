import QtQuick
import QtQuick.Layouts

import "../Commons/"

Text {
    id: root

    property string icon: ""
    property real pointSize: Style.fontSizeL
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

    font.family: Style.fontName
    font.pointSize: applyUiScale ? root.pointSize * Style.uiScaleRatio : root.pointSize
    color: Color.mOnSurface
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
}
