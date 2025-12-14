import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import "./"
import "../Commons/"

Item {
    id: root

    // --- Configuration ---
    property real baseSize: 70 * Style.uiScaleRatio

    // Logic: Provided by Main. Defaults to empty.
    property string imageSource: ""

    Layout.preferredWidth: baseSize
    Layout.preferredHeight: baseSize
    Layout.alignment: Qt.AlignVCenter

    onImageSourceChanged: {
        console.log("source image:", imageSource);
    }

    // ---------------------------------------------------------
    // 1. ANIMATED BORDER RING
    // ---------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: Color.transparent

        border.color: Qt.alpha(Color.mPrimary, 0.8)
        border.width: 2 * Style.uiScaleRatio

        SequentialAnimation on border.color {
            loops: Animation.Infinite
            ColorAnimation {
                to: Qt.alpha(Color.mPrimary, 1.0)
                duration: 2000
                easing.type: Easing.InOutQuad
            }
            ColorAnimation {
                to: Qt.alpha(Color.mPrimary, 0.4)
                duration: 2000
                easing.type: Easing.InOutQuad
            }
        }
    }

    // ---------------------------------------------------------
    // 2. THE AVATAR IMAGE
    // ---------------------------------------------------------
    Item {
        id: imageContainer
        anchors.centerIn: parent
        width: parent.width - (4 * Style.uiScaleRatio)
        height: width

        // Actual Image
        Image {
            id: avatarImg
            anchors.fill: parent
            source: root.imageSource

            fillMode: Image.PreserveAspectCrop
            visible: true
            asynchronous: true
            cache: false

            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: mask
            }
            Rectangle {
                id: mask
                radius: height / 2
                anchors.fill: avatarImg
                visible: false
                layer.enabled: true
            }
        }

        // ---------------------------------------------------------
        // 3. FALLBACK ICON
        // ---------------------------------------------------------
        Item {
            anchors.fill: parent
            // Show if source is empty OR if image failed to load (Error/Null/Loading)
            visible: root.imageSource === "" || avatarImg.status !== Image.Ready

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: Qt.alpha(Color.mSurface, 0.5)
            }

            NIcon {
                anchors.centerIn: parent
                icon: "user"
                pointSize: Style.fontSizeXXL
                color: Color.mOnSurface
            }
        }
    }
}
