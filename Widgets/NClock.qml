import QtQuick
import QtQuick.Layouts

import "./"
import "../Commons/"

Item {
    id: root

    // --- TIME KEEPING ---
    // SDDM doesn't provide a global 'Time' object, so we run our own timer.
    property var now: new Date()
    Timer {
        interval: 100 // Update every 100ms for smooth second hand movement
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    // --- PROPERTIES ---
    property string clockStyle: "analog" // "analog" or "digital"

    property color backgroundColor: Color.mPrimary
    property color clockColor: Color.mOnPrimary
    property color secondHandColor: Color.mError
    property color progressColor: root.secondHandColor

    property real hoursFontSize: Style.fontSizeXL
    property real minutesFontSize: Style.fontSizeM

    // Size calculation (Adapted to Style)
    height: Style.baseWidgetSize * 3
    width: height

    Loader {
        id: clockLoader
        anchors.fill: parent
        sourceComponent: root.clockStyle === "analog" ? analogClockComponent : digitalClockComponent
    }

    // ---------------------------------------------------------
    // COMPONENT: ANALOG CLOCK
    // ---------------------------------------------------------
    Component {
        id: analogClockComponent
        Item {
            anchors.fill: parent

            Canvas {
                id: clockCanvas
                anchors.fill: parent

                // Repaint when time changes
                onPaint: {
                    var currentTime = root.now;
                    var hours = currentTime.getHours();
                    var minutes = currentTime.getMinutes();
                    var seconds = currentTime.getSeconds();
                    var milliseconds = currentTime.getMilliseconds(); // For smoother movement

                    var ctx = getContext("2d");
                    ctx.reset();

                    var centerX = width / 2;
                    var centerY = height / 2;
                    var radius = Math.min(width, height) / 2;

                    ctx.translate(centerX, centerY);

                    // 1. Draw Hour Marks
                    ctx.strokeStyle = Qt.alpha(root.clockColor, 0.5);
                    ctx.lineWidth = 2 * Style.uiScaleRatio;

                    for (var i = 0; i < 12; i++) {
                        var scaleFactor = (i % 3 === 0) ? 0.65 : 0.8;
                        ctx.save();
                        ctx.rotate(i * Math.PI / 6);
                        ctx.beginPath();
                        ctx.moveTo(0, -radius * scaleFactor);
                        ctx.lineTo(0, -radius);
                        ctx.stroke();
                        ctx.restore();
                    }

                    // 2. Hour Hand
                    ctx.save();
                    var hourAngle = (hours % 12 + minutes / 60) * Math.PI / 6;
                    ctx.rotate(hourAngle);
                    ctx.strokeStyle = root.clockColor;
                    ctx.lineWidth = 3 * Style.uiScaleRatio;
                    ctx.lineCap = "round";
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(0, -radius * 0.55);
                    ctx.stroke();
                    ctx.restore();

                    // 3. Minute Hand
                    ctx.save();
                    var minuteAngle = (minutes + seconds / 60) * Math.PI / 30;
                    ctx.rotate(minuteAngle);
                    ctx.strokeStyle = root.clockColor;
                    ctx.lineWidth = 2 * Style.uiScaleRatio;
                    ctx.lineCap = "round";
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(0, -radius * 0.85);
                    ctx.stroke();
                    ctx.restore();

                    // 4. Second Hand (Red)
                    ctx.save();
                    // Smooth sweep: seconds + ms
                    var secondAngle = (seconds + milliseconds / 1000) * Math.PI / 30;
                    ctx.rotate(secondAngle);
                    ctx.strokeStyle = root.secondHandColor;
                    ctx.lineWidth = 1.5 * Style.uiScaleRatio;
                    ctx.lineCap = "round";
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(0, -radius);
                    ctx.stroke();
                    ctx.restore();

                    // Center Dot
                    ctx.beginPath();
                    ctx.arc(0, 0, 3 * Style.uiScaleRatio, 0, 2 * Math.PI);
                    ctx.fillStyle = root.clockColor;
                    ctx.fill();
                }

                // Trigger repaint on time change
                Connections {
                    target: root
                    function onNowChanged() {
                        clockCanvas.requestPaint();
                    }
                }
            }
        }
    }

    // ---------------------------------------------------------
    // COMPONENT: DIGITAL CLOCK
    // ---------------------------------------------------------
    Component {
        id: digitalClockComponent
        Item {
            anchors.fill: parent

            // Circular Seconds Progress
            Canvas {
                id: secondsProgress
                anchors.fill: parent

                property real progress: (root.now.getSeconds() * 1000 + root.now.getMilliseconds()) / 60000

                onPaint: {
                    var ctx = getContext("2d");
                    var centerX = width / 2;
                    var centerY = height / 2;
                    var radius = Math.min(width, height) / 2 - 3;
                    ctx.reset();

                    // Background Circle (Faint)
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
                    ctx.lineWidth = 2.5;
                    ctx.strokeStyle = Qt.alpha(root.clockColor, 0.15);
                    ctx.stroke();

                    // Progress Arc (Colored)
                    ctx.beginPath();
                    // Start from top (-90 degrees or -PI/2)
                    ctx.arc(centerX, centerY, radius, -Math.PI / 2, -Math.PI / 2 + progress * 2 * Math.PI);
                    ctx.lineWidth = 2.5;
                    ctx.strokeStyle = root.progressColor;
                    ctx.lineCap = "round";
                    ctx.stroke();
                }

                // Repaint when time changes
                Connections {
                    target: root
                    function onNowChanged() {
                        secondsProgress.progress = (root.now.getSeconds() * 1000 + root.now.getMilliseconds()) / 60000;
                        secondsProgress.requestPaint();
                    }
                }
            }

            // Digital Text Stack
            ColumnLayout {
                anchors.centerIn: parent
                spacing: -Style.marginS

                NText {
                    // HH or hh based on preference (defaulting to 24h for SDDM usually)
                    text: Qt.formatTime(root.now, "HH")
                    pointSize: root.hoursFontSize
                    font.weight: Style.fontWeightBold
                    color: root.clockColor
                    Layout.alignment: Qt.AlignHCenter
                }

                NText {
                    text: Qt.formatTime(root.now, "mm")
                    pointSize: root.minutesFontSize
                    font.weight: Style.fontWeightBold
                    color: root.clockColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
