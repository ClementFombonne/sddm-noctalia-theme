import QtQuick
import QtQuick.Layouts

import "../Commons/"

Text {
    id: root

    property string icon: ""
    property real pointSize: Style.fontSizeL
    property bool applyUiScale: true

    function getIconChar(iconName) {
        if (!iconName)
            return "";

        var effectiveName = IconsTabler.aliases[iconName] || iconName;
        var unicode = IconsTabler.icons[effectiveName];
        return unicode !== undefined ? unicode : "";
    }

    visible: (icon !== undefined) && (icon !== "")
    text: getIconChar(icon)

    font.family: Style.fontName
    font.pointSize: applyUiScale ? root.pointSize * Style.uiScaleRatio : root.pointSize
    color: Color.mOnSurface
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
}
