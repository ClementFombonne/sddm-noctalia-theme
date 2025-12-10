import QtQuick
import QtQuick.Layouts

import "./"

RowLayout {
    id: passwordRoot

    Layout.fillWidth: true
    spacing: 0

    signal accepted(string password)
    property bool uiEnabled: true

    function forceFocus() {
        passwordInput.forceActiveFocus();
    }
    function clear() {
        passwordInput.text = "";
    }

    Item {
        Layout.preferredWidth: NStyle.marginM
    }

    Rectangle {
        id: inputBackground

        Layout.fillWidth: true
        Layout.preferredHeight: 48
        radius: NStyle.radiusL
        color: NColors.mSurface
        border.color: passwordInput.activeFocus ? NColors.mPrimary : Qt.alpha(NColors.mOutline, 0.3)
        border.width: passwordInput.activeFocus ? 2 : 1

        property bool passwordVisible: false

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14

            NIcon {
                icon: "lock"
                pointSize: NStyle.fontSizeL
                color: passwordInput.activeFocus ? NColors.mPrimary : NColors.mOnSurfaceVariant
                anchors.verticalCenter: parent.verticalCenter
            }

            // Hidden input that receives actual text
            TextInput {
                id: passwordInput
                width: 0
                height: 0
                visible: false
                enabled: passwordRoot.uiEnabled
                font.pointSize: NStyle.fontSizeM
                color: NColors.mPrimary
                echoMode: inputBackground.passwordVisible ? TextInput.Normal : TextInput.Password
                passwordCharacter: "•"
                passwordMaskDelay: 0

                Keys.onPressed: function (event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        passwordRoot.accepted(text);
                    }
                }

                Component.onCompleted: forceActiveFocus()
            }

            Row {
                spacing: 0

                Rectangle {
                    width: 2
                    height: 20
                    color: NColors.mPrimary
                    visible: passwordInput.activeFocus && passwordInput.text.length === 0
                    anchors.verticalCenter: parent.verticalCenter

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        running: passwordInput.activeFocus && passwordInput.text.length === 0
                        NumberAnimation {
                            to: 0
                            duration: 530
                        }
                        NumberAnimation {
                            to: 1
                            duration: 530
                        }
                    }
                }

                // Password display - show dots or actual text based on passwordVisible
                Item {
                    width: Math.min(passwordDisplayContent.width, 550)
                    height: 20
                    visible: passwordInput.text.length > 0 && !inputBackground.passwordVisible
                    anchors.verticalCenter: parent.verticalCenter
                    clip: true

                    Row {
                        id: passwordDisplayContent
                        spacing: 6
                        anchors.verticalCenter: parent.verticalCenter

                        Repeater {
                            model: passwordInput.text.length

                            NIcon {
                                icon: "circle-filled"
                                pointSize: NStyle.fontSizeS
                                color: NColors.mPrimary
                                opacity: 1.0
                            }
                        }
                    }
                }

                NText {
                    text: passwordInput.text
                    color: NColors.mPrimary
                    pointSize: NStyle.fontSizeM
                    font.weight: Font.Medium
                    visible: passwordInput.text.length > 0 && inputBackground.passwordVisible
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    width: Math.min(implicitWidth, 550)
                }

                Rectangle {
                    width: 2
                    height: 20
                    color: NColors.mPrimary
                    visible: passwordInput.activeFocus && passwordInput.text.length > 0
                    anchors.verticalCenter: parent.verticalCenter

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        running: passwordInput.activeFocus && passwordInput.text.length > 0
                        NumberAnimation {
                            to: 0
                            duration: 530
                        }
                        NumberAnimation {
                            to: 1
                            duration: 530
                        }
                    }
                }
            }
        }

        // Eye button to toggle password visibility
        Rectangle {
            anchors.right: submitButton.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            radius: Math.min(NStyle.radiusL, width / 2)
            color: eyeButtonArea.containsMouse ? NColors.mPrimary : NColors.transparent
            visible: passwordInput.text.length > 0
            enabled: passwordRoot.uiEnabled

            NIcon {
                anchors.centerIn: parent
                icon: inputBackground.passwordVisible ? "eye-off" : "eye"
                pointSize: NStyle.fontSizeM
                color: eyeButtonArea.containsMouse ? NColors.mOnPrimary : NColors.mOnSurfaceVariant

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
            }

            MouseArea {
                id: eyeButtonArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: inputBackground.passwordVisible = !inputBackground.passwordVisible
            }

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }

        // Submit button
        Rectangle {
            id: submitButton
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            radius: Math.min(NStyle.radiusL, width / 2)
            color: submitButtonArea.containsMouse ? NColors.mPrimary : NColors.transparent
            border.color: NColors.mPrimary
            border.width: NStyle.borderS
            enabled: passwordRoot.uiEnabled

            NIcon {
                anchors.centerIn: parent
                icon: "arrow-forward"
                pointSize: NStyle.fontSizeM
                color: submitButtonArea.containsMouse ? NColors.mOnPrimary : NColors.mPrimary

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
            }

            MouseArea {
                id: submitButtonArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: passwordRoot.accepted(passwordInput.text)
            }

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }

    Item {
        Layout.preferredWidth: NStyle.marginM
    }
}
