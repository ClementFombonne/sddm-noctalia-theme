import QtQuick
import QtQuick.Layouts

import "./"

Text {
    id: root

    property bool richTextEnabled: false
    property string family: config.fontFamily
    property real pointSize: NStyle.fontSizeM
    property bool applyUiScale: true
    property real fontScale: {
        if (applyUiScale) {
            return config.fontScale * NStyle.uiScaleRatio;
        }
        return config.fontScale;
    }

    font.family: root.family
    font.weight: NStyle.fontWeightMedium
    font.pointSize: root.pointSize * fontScale
    color: NColors.mOnSurface
    elide: Text.ElideRight
    wrapMode: Text.NoWrap
    verticalAlignment: Text.AlignVCenter

    textFormat: richTextEnabled ? Text.RichText : Text.PlainText
}
