import Quickshell
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import QtQuick.Controls
import Quickshell.Io

import Quickshell.Wayland

import qs
import qs.modules.statusBar

WlrLayershell {
    id: root

    layer: WlrLayer.Top
    visible: true

    IpcHandler {
        target: root.screen?.name || "root"
        function toggleOverlay(): void { root.layer = (root.layer === WlrLayer.Overlay ? WlrLayer.Top : WlrLayer.Overlay);}
        function toggleVisibility(): void {
            root.visible = !root.visible;
            hyprlandGapsOut.exec(["sh", "-c", "hyprctl getoption general:gaps_out -j"]);
        }
    }

    Process {
        id: hyprlandGapsOut
        stdout: StdioCollector {
	    onStreamFinished: () => {
		const params = JSON.parse(data).css.split(/\s+/);
                const topGap = `top = ${root.visible ? 0 : params[0]}`;
                const otherGaps = `left = ${params[1]}, right = ${params[2]}, bottom = ${params[3]}`;
		const screenName = root.screen?.name || undefined;
                hyprlandGapsOut.exec(["sh", "-c", `hyprctl eval 'hl.workspace_rule({ workspace = "m[${screenName}]", gaps_out = { ${topGap}, ${otherGaps} } })'`]);
            }
        }
    }

    anchors.left: true
    anchors.right: true
    anchors.top: true

    color: "transparent"

    implicitHeight: 48

    Rectangle {
        id: rect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        anchors.margins: 6

        implicitHeight:36

        color: Theme.addAlpha(Theme.colSurface, Theme.lightAlpha)

        radius: Theme.radius

        Item {
            anchors.fill: parent

            anchors.leftMargin: 6
            anchors.rightMargin: 6
            anchors.topMargin: 3
            anchors.bottomMargin: 3

            RowLayout {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                spacing: Theme.fontSize

                AppMenuButton {}
            }

            RowLayout {
                anchors.centerIn: parent;
                HyprlandWorkspaces { screen: root.screen }
            }

            RowLayout {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                spacing: Theme.fontSize

                RowLayout {
                    Bluetooth {}

                    Networks {}

                    Audio {}

                    Battery {}
                    //onClicked:
                }

                Clock {}
            }
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
