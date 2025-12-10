import QtQuick
import QtQuick.Layouts
import SddmComponents 2.0 as Sddm
import QtQuick.Controls

import "./widgets"

FocusScope {
    id: root
    width: 1920
    height: 1080

    // --- LOGIC VARIABLES ---
    property int currentSessionIndex: sessionModel.lastIndex
    property bool uiEnabled: true
    property string loginErrorMessage: ""
    property string currentTime: Qt.formatDateTime(new Date(), "hh:mm")
    property string currentDate: Qt.formatDateTime(new Date(), "dddd, MMMM d")

    property bool loggingIn: false

    property string currentUserName: userModel.lastUser
    Repeater {
        model: userModel
        delegate: Item {
            Component.onCompleted: {
                if (index === 0 && root.currentUserName === "") {
                    console.log("lastUser was empty. Auto-selecting first user:", name);
                    root.currentUserName = name;
                }
            }
        }
    }

    function startLogin(password) {
        if (password == "") {
            console.log("Error: Password is empty");
            return;
        }

        console.log("---------------- LOGIN ATTEMPT ----------------");
        console.log("User:", root.currentUserName);
        console.log("Pass:", password);
        console.log("Session Index:", root.currentSessionIndex);

        if (!root.currentUserName) {
            console.log("ERROR: currentUserName is undefined or empty!");
            // Temporary fix for testing: hardcode a user
            // root.currentUserName = "clement"
            return;
        }

        root.loginErrorMessage = "";
        root.uiEnabled = false;
        root.loggingIn = true;

        sddm.login(root.currentUserName, password, root.currentSessionIndex);
    }

    // --- LOAD FONT ---
    FontLoader {
        id: iconFontLoader
        source: "assets/font/tabler-icons.ttf"
    }
    property string iconFont: iconFontLoader.name
    // --- CLOCK TIMER ---
    // QML doesn't update time automatically, we need a timer

    // ---------------------------------------------------------
    // 1. BACKGROUND
    // ---------------------------------------------------------
    Image {
        id: lockBgImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: config.background || "assets/background.jpg"
        cache: true
        smooth: true
        mipmap: false
        antialiasing: true
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: Qt.alpha(NColors.mShadow, 0.8)
            }
            GradientStop {
                position: 0.3
                color: Qt.alpha(NColors.mShadow, 0.4)
            }
            GradientStop {
                position: 0.7
                color: Qt.alpha(NColors.mShadow, 0.5)
            }
            GradientStop {
                position: 1.0
                color: Qt.alpha(NColors.mShadow, 0.9)
            }
        }
    }

    // Screen corners for lock screen
    Item {
        anchors.fill: parent
        visible: true

        property color cornerColor: NColors.black // Qt.alpha(NColors.mSurface, config.backgroundOpacity)
        property real cornerRadius: NStyle.screenRadius
        property real cornerSize: NStyle.screenRadius

        // Top-left concave corner
        Canvas {
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.cornerSize
            height: parent.cornerSize
            antialiasing: true
            renderTarget: Canvas.FramebufferObject
            smooth: false

            onPaint: {
                const ctx = getContext("2d");
                if (!ctx)
                    return;
                ctx.reset();
                ctx.clearRect(0, 0, width, height);

                ctx.fillStyle = parent.cornerColor;
                ctx.fillRect(0, 0, width, height);

                ctx.globalCompositeOperation = "destination-out";
                ctx.fillStyle = "#ffffff";
                ctx.beginPath();
                ctx.arc(width, height, parent.cornerRadius, 0, 2 * Math.PI);
                ctx.fill();
            }

            onWidthChanged: if (available)
                requestPaint()
            onHeightChanged: if (available)
                requestPaint()
        }

        // Top-right concave corner
        Canvas {
            anchors.top: parent.top
            anchors.right: parent.right
            width: parent.cornerSize
            height: parent.cornerSize
            antialiasing: true
            renderTarget: Canvas.FramebufferObject
            smooth: true

            onPaint: {
                const ctx = getContext("2d");
                if (!ctx)
                    return;
                ctx.reset();
                ctx.clearRect(0, 0, width, height);

                ctx.fillStyle = parent.cornerColor;
                ctx.fillRect(0, 0, width, height);

                ctx.globalCompositeOperation = "destination-out";
                ctx.fillStyle = "#ffffff";
                ctx.beginPath();
                ctx.arc(0, height, parent.cornerRadius, 0, 2 * Math.PI);
                ctx.fill();
            }

            onWidthChanged: if (available)
                requestPaint()
            onHeightChanged: if (available)
                requestPaint()
        }

        // Bottom-left concave corner
        Canvas {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.cornerSize
            height: parent.cornerSize
            antialiasing: true
            renderTarget: Canvas.FramebufferObject
            smooth: true

            onPaint: {
                const ctx = getContext("2d");
                if (!ctx)
                    return;
                ctx.reset();
                ctx.clearRect(0, 0, width, height);

                ctx.fillStyle = parent.cornerColor;
                ctx.fillRect(0, 0, width, height);

                ctx.globalCompositeOperation = "destination-out";
                ctx.fillStyle = "#ffffff";
                ctx.beginPath();
                ctx.arc(width, 0, parent.cornerRadius, 0, 2 * Math.PI);
                ctx.fill();
            }

            onWidthChanged: if (available)
                requestPaint()
            onHeightChanged: if (available)
                requestPaint()
        }

        // Bottom-right concave corner
        Canvas {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.cornerSize
            height: parent.cornerSize
            antialiasing: true
            renderTarget: Canvas.FramebufferObject
            smooth: true

            onPaint: {
                const ctx = getContext("2d");
                if (!ctx)
                    return;
                ctx.reset();
                ctx.clearRect(0, 0, width, height);

                ctx.fillStyle = parent.cornerColor;
                ctx.fillRect(0, 0, width, height);

                ctx.globalCompositeOperation = "destination-out";
                ctx.fillStyle = "#ffffff";
                ctx.beginPath();
                ctx.arc(0, 0, parent.cornerRadius, 0, 2 * Math.PI);
                ctx.fill();
            }

            onWidthChanged: if (available)
                requestPaint()
            onHeightChanged: if (available)
                requestPaint()
        }
    }

    // ---------------------------------------------------------
    // 2. TOP RECTANGLE (Clock & User)
    // ---------------------------------------------------------
    Item {
        anchors.fill: parent
        Rectangle {
            width: Math.max(500, contentRow.implicitWidth + 32)
            height: Math.max(120, contentRow.implicitHeight + 32)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            radius: NStyle.radiusL
            color: NColors.mSurface
            border.color: Qt.alpha(NColors.mOutline, 0.2)
            border.width: 1

            RowLayout {
                id: contentRow
                anchors.centerIn: parent
                anchors.margins: 16
                spacing: 32

                NAvatar {
                    currentUserName: root.currentUserName
                }

                ColumnLayout {
                    // User Name
                    NText {
                        text: "Welcome"
                        pointSize: NStyle.fontSizeXXL
                        font.weight: NStyle.fontWeightMedium
                        color: NColors.mOnSurface
                        horizontalAlignment: Text.AlignLeft
                    }

                    // Date
                    NText {
                        text: root.currentDate
                        pointSize: NStyle.fontSizeXL
                        font.weight: NStyle.fontWeightMedium
                        color: NColors.mOnSurfaceVariant
                        horizontalAlignment: Text.AlignLeft
                    }
                }
                // Spacer
                Item {
                    width: 20
                    height: 1
                }
                NClock {
                    clockStyle: config.clockStyle
                    Layout.preferredWidth: 70
                    Layout.preferredHeight: 70
                    Layout.alignment: Qt.AlignVCenter
                    backgroundColor: NColors.mSurface
                    clockColor: NColors.mOnSurface
                    secondHandColor: NColors.mPrimary
                    hoursFontSize: NStyle.fontSizeL
                    minutesFontSize: NStyle.fontSizeL
                }
            }
        }

        // Error notification
        Rectangle {

            visible: root.loginErrorMessage !== ""
            opacity: visible ? 1.0 : 0.0

            width: errorRowLayout.implicitWidth + NStyle.marginXL * 1.5
            height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: (config.compact == "true" ? 280 : 360) * NStyle.uiScaleRatio
            radius: NStyle.radiusL
            color: NColors.mError
            border.color: NColors.mError
            border.width: 1

            RowLayout {
                id: errorRowLayout
                anchors.centerIn: parent
                spacing: 10

                NIcon {
                    icon: "alert-circle"
                    pointSize: NStyle.fontSizeL
                    color: NColors.mOnError
                }

                NText {
                    text: root.loginErrorMessage || "Authentication failed"
                    color: NColors.mOnError
                    pointSize: NStyle.fontSizeL
                    font.weight: NStyle.fontWeightMedium
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
        }
        // ---------------------------------------------------------
        // 2.5 STATUS BAR (Keyboard & Battery)
        // ---------------------------------------------------------
        Rectangle {
            id: statusBar

            NBattery {
                id: battery
            }

            // --- LOGIC ---
            // property bool hasKeyboard: true
            property bool hasKeyboard: keyboard.layouts.length > 1
            // Show if at least one status is available (Compact mode check removed as requested)
            visible: battery.isReady || hasKeyboard

            // --- POSITIONING ---
            // Anchored to sit exactly on top of the bottomContainer
            anchors.horizontalCenter: bottomContainer.horizontalCenter
            anchors.bottom: bottomContainer.top
            anchors.bottomMargin: -NStyle.radiusL // Overlap slightly to look connected
            z: -1 // Send behind bottomContainer so the rounded corners look like a tab

            // --- SIZE ---
            height: 40 + NStyle.radiusL // Add radius to height for the overlap
            width: {
                if (battery.isReady && hasKeyboard)
                    return 200 * NStyle.uiScaleRatio;
                if (battery.isReady || hasKeyboard)
                    return 120 * NStyle.uiScaleRatio;
                return 0;
            }

            // --- STYLING ---
            // Only round top corners
            radius: NStyle.radiusL
            color: NColors.mSurface

            // Since we are simulating top-only radius with z-index overlap,
            // we don't need complex canvas drawing here.

            RowLayout {
                anchors.top: parent.top
                anchors.topMargin: 10 // Padding from top edge
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                // Battery Indicator (Hidden by default in standard SDDM)
                RowLayout {
                    spacing: 6
                    visible: battery.isReady

                    NIcon {
                        // Logic to choose icon based on state
                        icon: {
                            if (battery.charging)
                                return "battery-charging";
                            if (battery.percent > 90)
                                return "battery-4"; // or "battery-full"
                            if (battery.percent > 60)
                                return "battery-3";
                            if (battery.percent > 30)
                                return "battery-2";
                            return "battery-1"; // or "battery-off" for low
                        }
                        pointSize: NStyle.fontSizeM
                        color: (battery.charging || battery.percent < 20) ? NColors.mPrimary : NColors.mOnSurfaceVariant
                    }

                    NText {
                        text: battery.percent + "%"
                        color: NColors.mOnSurfaceVariant
                        pointSize: NStyle.fontSizeM
                        font.weight: NStyle.fontWeightMedium
                    }
                }
                // Keyboard Layout Indicator
                Item {
                    visible: statusBar.hasKeyboard

                    Layout.preferredWidth: kbContent.implicitWidth
                    Layout.preferredHeight: kbContent.implicitHeight

                    RowLayout {
                        id: kbContent
                        spacing: 6
                        visible: statusBar.hasKeyboard

                        NIcon {
                            icon: "keyboard"
                            pointSize: NStyle.fontSizeM
                            color: NColors.mOnSurfaceVariant
                        }

                        NText {
                            // Uses SDDM standard property
                            text: keyboard.currentLayout || "en"
                            color: NColors.mOnSurfaceVariant
                            pointSize: NStyle.fontSizeM
                            font.weight: NStyle.fontWeightMedium
                            elide: Text.ElideRight
                        }

                        // Optional: Make it clickable to cycle layouts
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: keyboard.nextLayout()
                        }
                    }
                }
            }
        }

        // ---------------------------------------------------------
        // 3. BOTTOM RECTANGLE (Input & Login)
        // ---------------------------------------------------------
        Rectangle {
            id: bottomContainer
            // Adjust height to fit the extra field
            height: (config.compact == "true") ? 180 : 280

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
            radius: NStyle.radiusL
            color: NColors.mSurface

            Component.onCompleted: passwordComponent.forceFocus()

            // Measure text widths to determine minimum button width
            Item {
                id: buttonRowTextMeasurer
                visible: false
                property real iconSize: NStyle.fontSizeM
                property real fontSize: NStyle.fontSizeS
                property real spacing: 6
                property real padding: 18

                Text {
                    id: logoutText
                    text: "Logout"
                    font.pointSize: parent.fontSize
                    font.weight: Font.Medium
                }
                Text {
                    id: suspendText
                    text: "Suspend"
                    font.pointSize: parent.fontSize
                    font.weight: Font.Medium
                }
                Text {
                    id: rebootText
                    text: "Reboot"
                    font.pointSize: parent.fontSize
                    font.weight: Font.Medium
                }
                Text {
                    id: shutdownText
                    text: "Shutdown"
                    font.pointSize: parent.fontSize
                    font.weight: Font.Medium
                }

                property real maxTextWidth: Math.max(logoutText.implicitWidth, Math.max(suspendText.implicitWidth, Math.max(rebootText.implicitWidth, shutdownText.implicitWidth)))
                property real minButtonWidth: maxTextWidth + iconSize + spacing + padding
            }

            property int buttonCount: 4
            property int spacingCount: buttonCount - 1
            property real minButtonRowWidth: buttonRowTextMeasurer.minButtonWidth > 0 ? (buttonCount * buttonRowTextMeasurer.minButtonWidth) + (spacingCount * 10) + 40 + (2 * NStyle.marginM) + 28 + (2 * NStyle.marginM) : 750
            width: Math.max(750, minButtonRowWidth)

            ColumnLayout {
                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 14
                spacing: 14

                // -------------------------------------------------
                // NEW: USER INPUT FIELD
                // -------------------------------------------------
                RowLayout {
                    id: userComponent
                    Layout.fillWidth: true
                    spacing: 0

                    Item {
                        Layout.preferredWidth: NStyle.marginM
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        radius: height / 2
                        color: NColors.mSurface

                        // Highlight border when focused
                        border.color: userInput.activeFocus ? NColors.mPrimary : Qt.alpha(NColors.mOutline, 0.3)
                        border.width: userInput.activeFocus ? 2 : 1

                        // MouseArea to ensure clicking anywhere focuses the input
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.IBeamCursor
                            onClicked: userInput.forceActiveFocus()
                        }

                        // The Input Field
                        TextInput {
                            id: userInput
                            anchors.fill: parent
                            anchors.leftMargin: 50 // Space for the icon
                            anchors.rightMargin: 18

                            text: root.currentUserName
                            font.pointSize: NStyle.fontSizeM
                            color: NColors.mOnSurface
                            verticalAlignment: TextInput.AlignVCenter
                            clip: true

                            // Update the main property when user types
                            onTextEdited: root.currentUserName = text

                            // On Enter, jump to password field
                            onAccepted: passwordComponent.forceFocus()
                        }

                        // The User Icon
                        NIcon {
                            icon: "user"
                            pointSize: NStyle.fontSizeL
                            color: userInput.activeFocus ? NColors.mPrimary : NColors.mOnSurfaceVariant
                            anchors.left: parent.left
                            anchors.leftMargin: 18
                            anchors.verticalCenter: parent.verticalCenter
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

                // -------------------------------------------------
                // EXISTING: PASSWORD INPUT
                // -------------------------------------------------
                RowLayout {
                    id: passwordComponent
                    Layout.fillWidth: true
                    spacing: 0

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
                        radius: height / 2
                        color: NColors.mSurface
                        border.color: passwordInput.activeFocus ? NColors.mPrimary : Qt.alpha(NColors.mOutline, 0.3)
                        border.width: passwordInput.activeFocus ? 2 : 1

                        property bool passwordVisible: false

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.IBeamCursor
                            onClicked: passwordInput.forceActiveFocus()
                        }

                        // Icon and Custom Text Visualization
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

                            // The actual input (Invisible but active)
                            TextInput {
                                id: passwordInput
                                width: 0
                                height: 0
                                visible: true
                                enabled: root.uiEnabled
                                font.pointSize: NStyle.fontSizeM
                                color: "transparent"
                                cursorDelegate: Item {}
                                echoMode: inputBackground.passwordVisible ? TextInput.Normal : TextInput.Password
                                passwordCharacter: "•"
                                passwordMaskDelay: 0

                                Keys.onPressed: function (event) {
                                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                        root.startLogin(text);
                                    }
                                }
                                // Focus handled by User Input or Defaults
                            }

                            // Visual representation (Dots/Text/Cursor)
                            Row {
                                spacing: 0

                                // Cursor Start
                                Rectangle {
                                    id: cursorStart
                                    width: 2
                                    height: 20
                                    color: NColors.mPrimary
                                    visible: passwordInput.activeFocus && passwordInput.text.length === 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    SequentialAnimation on opacity {
                                        loops: Animation.Infinite
                                        running: cursorStart.visible
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

                                // Dots
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

                                // Actual Text
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

                                // Cursor End
                                Rectangle {
                                    id: cursorEnd
                                    width: 2
                                    height: 20
                                    color: NColors.mPrimary
                                    visible: passwordInput.activeFocus && passwordInput.text.length > 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    SequentialAnimation on opacity {
                                        loops: Animation.Infinite
                                        running: cursorEnd.visible
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

                        // Eye button
                        Rectangle {
                            anchors.right: submitButton.left
                            anchors.rightMargin: 4
                            anchors.verticalCenter: parent.verticalCenter
                            width: 36
                            height: 36
                            radius: height / 2
                            color: eyeButtonArea.containsMouse ? NColors.mPrimary : NColors.transparent
                            visible: passwordInput.text.length > 0
                            enabled: root.uiEnabled

                            NIcon {
                                anchors.centerIn: parent
                                icon: inputBackground.passwordVisible ? "eye-off" : "eye"
                                pointSize: NStyle.fontSizeM
                                color: eyeButtonArea.containsMouse ? NColors.mOnPrimary : NColors.mOnSurfaceVariant
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
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
                            radius: height / 2
                            color: submitButtonArea.containsMouse ? NColors.mPrimary : NColors.transparent
                            border.color: NColors.mPrimary
                            border.width: NStyle.borderS
                            enabled: root.uiEnabled

                            NIcon {
                                anchors.centerIn: parent
                                icon: "arrow-forward"
                                pointSize: NStyle.fontSizeM
                                color: submitButtonArea.containsMouse ? NColors.mOnPrimary : NColors.mPrimary
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                            }

                            MouseArea {
                                id: submitButtonArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.startLogin(passwordInput.text)
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
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

                // -------------------------------------------------
                // SESSION & POWER BUTTONS
                // -------------------------------------------------
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: (config.compact == "true") ? 36 : 48
                    spacing: 0

                    Item {
                        Layout.preferredWidth: NStyle.marginM
                    }

                    NComboBox {
                        Layout.fillWidth: true
                        model: sessionModel
                        currentIndex: sessionModel.lastIndex
                        onActivated: index => {
                            sessionModel.lastIndex = index;
                            root.currentSessionIndex = index;
                            passwordComponent.forceFocus();
                        }
                        onPopupClosed: passwordComponent.forceFocus()
                    }

                    Item {
                        Layout.preferredWidth: 10
                    }

                    NButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        icon: "suspend"
                        text: "Suspend"
                        outlined: true
                        backgroundColor: NColors.mOnSurfaceVariant
                        textColor: NColors.mOnPrimary
                        hoverColor: NColors.mPrimary
                        fontSize: (config.compact == "true") ? NStyle.fontSizeS : NStyle.fontSizeM
                        iconSize: (config.compact == "true") ? NStyle.fontSizeM : NStyle.fontSizeL
                        fontWeight: NStyle.fontWeightMedium
                        horizontalAlignment: Qt.AlignHCenter
                        buttonRadius: NStyle.radiusL
                        onClicked: sddm.suspend()
                    }

                    Item {
                        Layout.preferredWidth: 10
                    }

                    NButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        icon: "reboot"
                        text: "Reboot"
                        outlined: true
                        backgroundColor: NColors.mOnSurfaceVariant
                        textColor: NColors.mOnPrimary
                        hoverColor: NColors.mPrimary
                        fontSize: (config.compact == "true") ? NStyle.fontSizeS : NStyle.fontSizeM
                        iconSize: (config.compact == "true") ? NStyle.fontSizeM : NStyle.fontSizeL
                        fontWeight: NStyle.fontWeightMedium
                        horizontalAlignment: Qt.AlignHCenter
                        buttonRadius: NStyle.radiusL
                        onClicked: sddm.reboot()
                    }

                    Item {
                        Layout.preferredWidth: 10
                    }

                    NButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        icon: "shutdown"
                        text: "Shutdown"
                        outlined: true
                        backgroundColor: NColors.mError
                        textColor: NColors.mOnError
                        hoverColor: NColors.mError
                        fontSize: (config.compact == "true") ? NStyle.fontSizeS : NStyle.fontSizeM
                        iconSize: (config.compact == "true") ? NStyle.fontSizeM : NStyle.fontSizeL
                        fontWeight: NStyle.fontWeightMedium
                        horizontalAlignment: Qt.AlignHCenter
                        buttonRadius: NStyle.radiusL
                        onClicked: sddm.powerOff()
                    }

                    Item {
                        Layout.preferredWidth: NStyle.marginM
                    }
                }
            }
        }
    }

    // ---------------------------------------------------------
    // 4. SIGNALS (Error Handling)
    // ---------------------------------------------------------
    Connections {
        target: sddm
        function onLoginSucceeded() {
            consol.log("Login Successful.")
        }
        function onLoginFailed() {
            root.loggingIn = false;

            root.loginErrorMessage = "Authentification failed";
            root.uiEnabled = true;

            passwordComponent.clear();
            passwordComponent.forceFocus();
        }
    }
}
