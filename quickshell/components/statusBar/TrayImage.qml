import QtQuick
import QtQuick.Effects

import qs

Rectangle {
    required property url iconSource
    required property color iconColor
    required property real widthCoefficient
    required property real heightCoefficient

    height: Theme.fontMiniSize * heightCoefficient
    width: Theme.fontMiniSize * widthCoefficient

    color: "transparent"

    Image {
        id: image

        source: parent.iconSource

        anchors.fill: parent
    }

    MultiEffect {
        source: image

        anchors.fill: image

        // Deprecated since svg colors are changed to white.
        //brightness: 1.0

        colorization: 1.0
        colorizationColor: parent.iconColor
    }
}
