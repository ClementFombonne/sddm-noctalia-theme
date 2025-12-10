import QtQuick
import QtQuick.Layouts
import SddmComponents 2.0 as Sddm // Required to see 'sessionModel'

import QtQuick.Controls 2.15

ComboBox {
    id: root

    // 1. Data Source
    // sessionModel is injected globally by SDDM
    model: sessionModel
    textRole: "name" // The name of the desktop environment (e.g. "Plasma (Wayland)")

    // 2. State Handling
    // Default to the last used session (remembered by SDDM)
    currentIndex: sessionModel.lastIndex

    // 3. Styling
    font.pixelSize: 14
    implicitWidth: 200 // Slightly wider than keyboard switcher to fit text
    implicitHeight: 40

    // Background (The button itself)
    background: Rectangle {
        color: root.down ? "#ddd" : "white"
        radius: 5
        border.color: root.activeFocus ? config.accentColor : "#ccc"
        border.width: 1
    }

    // Text Display
    contentItem: Text {
        text: parent.displayText
        color: "black"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight // Cut off text with "..." if too long
        font: root.font
        leftPadding: 10
        rightPadding: 10
    }

    // Dropdown Popup Styling (Optional, but makes it look nicer)
    popup: Popup {
        y: root.height - 1
        width: root.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: root.popup.visible ? root.delegateModel : null
            currentIndex: root.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
            border.color: "#ccc"
            radius: 5
            color: "white"
        }
    }
}
