import QtQuick
import QtQuick.Layouts
import QtQuick.Effects // Needed for MultiEffect (Qt6) or OpacityMask (Qt5)
import "./"

Item {
    id: root

    // --- Configuration ---
    // Base size (scaled)
    property real baseSize: 70 * NStyle.uiScaleRatio

    // Logic:
    // 1. Try to use the face of the currently selected user (from userModel)
    // 2. If valid, use config.DefaultAvatar
    // 3. Fallback to a generic icon
    property string currentUserName: "" // Passed from main
    property string imageSource: {
        // Note: In SDDM, finding the exact user icon path can be tricky.
        // Often we rely on the config image or a standard icon.
        if (config.DefaultAvatar && config.DefaultAvatar !== "")
            return config.DefaultAvatar;
        return ""; // Will trigger fallback icon
    }

    Layout.preferredWidth: baseSize
    Layout.preferredHeight: baseSize
    Layout.alignment: Qt.AlignVCenter

    // ---------------------------------------------------------
    // 1. ANIMATED BORDER RING
    // ---------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: NColors.transparent

        // Animated Border Color
        border.color: Qt.alpha(NColors.mPrimary, 0.8)
        border.width: 2 * NStyle.uiScaleRatio

        SequentialAnimation on border.color {
            loops: Animation.Infinite
            ColorAnimation {
                to: Qt.alpha(NColors.mPrimary, 1.0)
                duration: 2000
                easing.type: Easing.InOutQuad
            }
            ColorAnimation {
                to: Qt.alpha(NColors.mPrimary, 0.4)
                duration: 2000
                easing.type: Easing.InOutQuad
            }
        }
    }

    // ---------------------------------------------------------
    // 2. THE AVATAR IMAGE (Standard Rounded Implementation)
    // ---------------------------------------------------------
    Item {
        id: imageContainer
        anchors.centerIn: parent
        width: parent.width - (4 * NStyle.uiScaleRatio) // Slightly smaller than border
        height: width

        // Breathing Scale Animation
        SequentialAnimation on scale {
            loops: Animation.Infinite
            NumberAnimation {
                to: 1.05
                duration: 4000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                to: 1.0
                duration: 4000
                easing.type: Easing.InOutQuad
            }
        }

        // Actual Image
        Image {
            id: avatarImg
            anchors.fill: parent
            source: root.imageSource
            sourceSize: Qt.size(width * 2, height * 2) // High DPI quality
            fillMode: Image.PreserveAspectCrop
            visible: false // Hidden because it is used as a source for the mask
            asynchronous: true
        }

        // The Mask (Circle)
        Rectangle {
            id: mask
            anchors.fill: parent
            radius: width / 2
            visible: false
        }

        // Apply Mask to Image
        MultiEffect {
            // NOTE: If you are on Qt5 (SDDM 0.20 or older), use OpacityMask from QtGraphicalEffects instead
            anchors.fill: parent
            source: avatarImg
            maskEnabled: true
            maskSource: mask
            visible: avatarImg.status === Image.Ready
        }

        // ---------------------------------------------------------
        // 3. FALLBACK ICON (If image is missing or loading)
        // ---------------------------------------------------------
        Item {
            anchors.fill: parent
            visible: avatarImg.status !== Image.Ready

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: Qt.alpha(NColors.mSurface, 0.5)
            }

            NIcon {
                anchors.centerIn: parent
                icon: "user" // Or "person" depending on your icon set
                pointSize: NStyle.fontSizeXXL
                color: NColors.mOnSurface
            }
        }
    }
}
