import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ComboBox {
    id: root

    // The 'keyboard' object is injected globally by SDDM.
    // It contains the list of enabled layouts in /etc/X11/xorg.conf.d/
    model: keyboard.layouts
    
    // Whatever is selected, tell SDDM to switch to it
    currentIndex: keyboard.currentLayout
    onActivated: (index) => {
        keyboard.currentLayout = index
    }

    // Display the "shortName" (e.g., 'us', 'fr') 
    // Usually the model data itself acts as the text, or has properties.
    // In many SDDM versions, the model is a list of objects with a 'shortName' property.
    textRole: "shortName"

    // --- STYLING (Customize this to match your theme) ---
    font.pixelSize: 14
    implicitWidth: 100
    implicitHeight: 40

    // The background of the button
    background: Rectangle {
        color: root.down ? "#ddd" : "white"
        radius: 5
        border.color: root.activeFocus ? config.accentColor : "#ccc"
        border.width: 1
    }

    // The text inside the button
    contentItem: Text {
        text: parent.displayText ? parent.displayText.toUpperCase() : ""
        color: "black"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font: root.font
    }
}
