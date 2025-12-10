import QtQuick

Item {
    id: root

    // --- Public Properties ---
    property bool isReady: false
    property int percent: 0
    property bool charging: false

    // --- Configuration ---
    // Change to BAT1 if your laptop uses a different ID
    readonly property string basePath: "file:///sys/class/power_supply/BAT1"

    // --- Timer to refresh status every 5 seconds ---
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.checkBattery()
    }

    // --- Logic ---
    function checkBattery() {
        // 1. Check if battery exists (read capacity)
        var capacity = readFile(basePath + "/capacity");

        if (capacity === "") {
            root.isReady = false;
            return;
        }

        // 2. Parse Percentage
        var p = parseInt(capacity);
        if (!isNaN(p)) {
            root.percent = p;
            root.isReady = true;
        }

        // 3. Check Status (Charging/Discharging/Full)
        var status = readFile(basePath + "/status").trim();
        root.charging = (status === "Charging");
    }

    // --- Helper to read file content via XMLHttpRequest ---
    // This is the standard hack to read local files in QML
    function readFile(source) {
        var xhr = new XMLHttpRequest;

        try {
            xhr.open("GET", source);
            xhr.send(null);

            if (xhr.status === 0 || xhr.status === 200) {
                return xhr.responseText;
            }
        } catch (e) {
            console.log("Battery read blocked by security policy (QML_XHR_ALLOW_FILE_READ=0)");
            return "";
        }

        return "";
    }
}
