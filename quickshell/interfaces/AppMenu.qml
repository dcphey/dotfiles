import Quickshell
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import QtQuick.Controls
import Quickshell.Io

import Quickshell.Wayland

import qs
import qs.modules.appMenu

WlrLayershell {
    layer: WlrLayer.Overlay
    visible: false

    property string output

    Process {
        id: aa
        running: true
        command: ["sh", AppMenuAssets.drunParser]
        stdout: StdioCollector {
            onStreamFinished: () => {
                //console.log(text);
                let output = JSON.parse(text).filter(e => e.NoDisplay != "true");
            }
        }
    }

    anchors.left: true
    anchors.top: true

    implicitWidth: 50 * Theme.fontSize

    color: "transparent"

    Rectangle {
        id: rect
        anchors.fill: parent

        anchors.margins: 6

        implicitHeight: 36

        color: Theme.addAlpha(Theme.colSurface, Theme.lightAlpha)

        radius: Theme.radius

        Text {
            text: "Apps"
            color: Theme.colOnSurface
            font { family: Theme.fontFamily; pointSize: Theme.fontEmphasizedSize; }

            anchors.margins: Theme.fontEmphasizedSize
            anchors.top: parent.top
            anchors.left: parent.left
        }

        ColumnLayout {

        }
    }

    RectangularShadow {
        anchors.fill: rect
        color: Theme.addAlpha(Theme.colShadow, Theme.lightShadowAlpha)
        blur: 3
        spread: 3
        radius: Theme.radius
    }
}
