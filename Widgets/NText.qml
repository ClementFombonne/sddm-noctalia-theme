import QtQuick
import QtQuick.Layouts

import "./"
import "../Commons/"

Text {
    id: root

    property bool richTextEnabled: false
    property string family: config.fontFamily
    property real pointSize: Style.fontSizeM
    property bool applyUiScale: true
    property real fontScale: {
        if (applyUiScale) {
            return config.fontScale * Style.uiScaleRatio;
        }
        return config.fontScale;
    }

    font.family: root.family
    font.weight: Style.fontWeightMedium
    font.pointSize: root.pointSize * fontScale
    color: Color.mOnSurface
    elide: Text.ElideRight
    wrapMode: Text.NoWrap
    verticalAlignment: Text.AlignVCenter

    textFormat: richTextEnabled ? Text.RichText : Text.PlainText
}
