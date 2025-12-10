pragma Singleton

import QtQuick

QtObject {
    id: root
    // Font size
    readonly property real fontSizeXXS: 8
    readonly property real fontSizeXS: 9
    readonly property real fontSizeS: 10
    readonly property real fontSizeM: 11
    readonly property real fontSizeL: 13
    readonly property real fontSizeXL: 16
    readonly property real fontSizeXXL: 18
    readonly property real fontSizeXXXL: 24

    // Font weight
    readonly property int fontWeightRegular: 400
    readonly property int fontWeightMedium: 500
    readonly property int fontWeightSemiBold: 600
    readonly property int fontWeightBold: 700

    // Icon Font
    property FontLoader _fontLoader: FontLoader {
        // Path is relative to THIS file (NStyle.qml)
        source: "../Assets/Fonts/tabler/tabler-icons.ttf"
    }
    readonly property string fontName: _fontLoader.name

    // Container Radii: major layout sections (sidebars, cards, content panels)
    readonly property int radiusXXS: Math.round(4 * config.radiusRatio)
    readonly property int radiusXS: Math.round(8 * config.radiusRatio)
    readonly property int radiusS: Math.round(12 * config.radiusRatio)
    readonly property int radiusM: Math.round(16 * config.radiusRatio)
    readonly property int radiusL: Math.round(20 * config.radiusRatio)

    // Input radii: interactive elements (buttons, toggles, text fields)
    readonly property int iRadiusXXS: Math.round(4 * config.iRadiusRatio)
    readonly property int iRadiusXS: Math.round(8 * config.iRadiusRatio)
    readonly property int iRadiusS: Math.round(12 * config.iRadiusRatio)
    readonly property int iRadiusM: Math.round(16 * config.iRadiusRatio)
    readonly property int iRadiusL: Math.round(20 * config.iRadiusRatio)

    readonly property int screenRadius: Math.round(20 * config.screenRadiusRatio)

    // Border
    readonly property int borderS: Math.max(1, Math.round(1 * uiScaleRatio))
    readonly property int borderM: Math.max(1, Math.round(2 * uiScaleRatio))
    readonly property int borderL: Math.max(1, Math.round(3 * uiScaleRatio))

    // Margins (for margins and spacing)
    readonly property int marginXXS: Math.round(2 * uiScaleRatio)
    readonly property int marginXS: Math.round(4 * uiScaleRatio)
    readonly property int marginS: Math.round(6 * uiScaleRatio)
    readonly property int marginM: Math.round(9 * uiScaleRatio)
    readonly property int marginL: Math.round(13 * uiScaleRatio)
    readonly property int marginXL: Math.round(18 * uiScaleRatio)

    // Opacity
    readonly property real opacityNone: 0.0
    readonly property real opacityLight: 0.25
    readonly property real opacityMedium: 0.5
    readonly property real opacityHeavy: 0.75
    readonly property real opacityAlmost: 0.95
    readonly property real opacityFull: 1.0

    // Widgets base size
    readonly property real baseWidgetSize: 33
    readonly property real sliderWidth: 200

    readonly property real uiScaleRatio: config.scaleRatio

    readonly property int animationFaster: Math.round(75 / config.animationSpeed)
    readonly property int animationFast: Math.round(150 / config.animationSpeed)
    readonly property int animationNormal: Math.round(300 / config.animationSpeed)
    readonly property int animationSlow: Math.round(450 / config.animationSpeed)
    readonly property int animationSlowest: Math.round(750 / config.animationSpeed)
}
