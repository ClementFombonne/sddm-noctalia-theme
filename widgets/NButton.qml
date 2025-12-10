import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // Public properties
    property string text: ""
    property string icon: ""
    property string tooltipText
    property color backgroundColor: NColors.mPrimary
    property color textColor: NColors.mOnPrimary
    property color hoverColor: NColors.mHover
    property bool enabled: true
    property real fontSize: NStyle.fontSizeM
    property int fontWeight: NStyle.fontWeightBold
    property real iconSize: NStyle.fontSizeL
    property bool outlined: false
    property int horizontalAlignment: Qt.AlignHCenter
    property real buttonRadius: NStyle.iRadiusS

    // Signals
    signal clicked
    signal rightClicked
    signal middleClicked
    signal entered
    signal exited

    // Internal properties
    property bool hovered: false

    // Dimensions
    implicitWidth: contentRow.implicitWidth + (NStyle.marginL * 2)
    implicitHeight: Math.max(NStyle.baseWidgetSize, contentRow.implicitHeight + (NStyle.marginM))

    // Appearance
    radius: root.buttonRadius
    color: {
        if (!enabled)
            return outlined ? NColors.transparent : Qt.lighter(NColors.mSurfaceVariant, 1.2);
        if (hovered)
            return hoverColor;
        return outlined ? NColors.transparent : backgroundColor;
    }

    border.width: outlined ? NStyle.borderS : 0
    border.color: {
        if (!enabled)
            return NColors.mOutline;
        if (hovered)
            return backgroundColor;
        return outlined ? backgroundColor : NColors.transparent;
    }

    opacity: enabled ? 1.0 : 0.6

    Behavior on color {
        ColorAnimation {
            duration: NStyle.animationFast
            easing.type: Easing.OutCubic
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: NStyle.animationFast
            easing.type: Easing.OutCubic
        }
    }

    // Content
    RowLayout {
        id: contentRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: root.horizontalAlignment === Qt.AlignLeft ? parent.left : undefined
        anchors.horizontalCenter: root.horizontalAlignment === Qt.AlignHCenter ? parent.horizontalCenter : undefined
        anchors.leftMargin: root.horizontalAlignment === Qt.AlignLeft ? NStyle.marginL : 0
        spacing: NStyle.marginXS

        // Icon (optional)
        NIcon {
            Layout.alignment: Qt.AlignVCenter
            visible: root.icon !== ""
            icon: root.icon
            pointSize: root.iconSize
            color: {
                if (!root.enabled)
                    return NColors.mOnSurfaceVariant;
                if (root.outlined) {
                    if (root.hovered)
                        return root.textColor;
                    return root.backgroundColor;
                }
                return root.textColor;
            }

            Behavior on color {
                ColorAnimation {
                    duration: NStyle.animationFast
                    easing.type: Easing.OutCubic
                }
            }
        }

        // Text
        NText {
            Layout.alignment: Qt.AlignVCenter
            visible: root.text !== ""
            text: root.text
            pointSize: root.fontSize
            font.weight: root.fontWeight
            color: {
                if (!root.enabled)
                    return NColors.mOnSurfaceVariant;
                if (root.outlined) {
                    if (root.hovered)
                        return root.textColor;
                    return root.backgroundColor;
                }
                return root.textColor;
            }

            Behavior on color {
                ColorAnimation {
                    duration: NStyle.animationFast
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    // Mouse interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onEntered: {
            root.hovered = true;
            root.entered();
            if (tooltipText) {
                TooltipService.show(root, root.tooltipText);
            }
        }
        onExited: {
            root.hovered = false;
            root.exited();
            if (tooltipText) {
                TooltipService.hide();
            }
        }
        onPressed: mouse => {
            if (tooltipText) {
                TooltipService.hide();
            }
            if (mouse.button === Qt.LeftButton) {
                root.clicked();
            } else if (mouse.button == Qt.RightButton) {
                root.rightClicked();
            } else if (mouse.button == Qt.MiddleButton) {
                root.middleClicked();
            }
        }

        onCanceled: {
            root.hovered = false;
            if (tooltipText) {
                TooltipService.hide();
            }
        }
    }
}
