import Quickshell
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import QtQuick.Controls
import Quickshell.Io

import Quickshell.Wayland

import qs
import qs.assets

WlrLayershell {
    id: root
    layer: WlrLayer.Overlay
    visible: false
    keyboardFocus: WlrKeyboardFocus.OnDemand

    IpcHandler {
        target: "powerMenu"
        function toggleMenu(): void {
            root.visible = !root.visible;
        }
    }

    property var actionList: [
        { icon: Assets.lock,     label: "Lock",     cmd: "loginctl lock-session", key: "l" },
        { icon: Assets.logout,   label: "Log Out",  cmd: "hyprshutdown",          key: "o" },
        { icon: Assets.suspend,  label: "Suspend",  cmd: "systemctl suspend",     key: "s" },
        { icon: Assets.restart,  label: "Restart",  cmd: "systemctl reboot",      key: "r", danger: true },
        { icon: Assets.shutdown, label: "Shutdown", cmd: "systemctl poweroff",    key: "u", danger: true },
    ]

    property int selectedIndex: 0

    onVisibleChanged: {
        if (visible) {
            selectedIndex = 0;
            keyboardHandler.focus = true;
        }
    }

    function runAction(action) {
        if (!action) return;
        Quickshell.execDetached(["sh", "-c", action.cmd]);
        root.visible = false;
    }

    Shortcut {
        sequence: "Escape"
        onActivated: root.visible = false
        enabled: visible
    }

    anchors.left: true
    anchors.right: true
    anchors.top: true
    anchors.bottom: true

    color: "transparent"

    MouseArea {
        anchors.fill: parent
        z: 0
    onClicked: root.visible = false
    }

    Rectangle {
        id: rect

        anchors.left: parent.left
        anchors.top: parent.top

        anchors.leftMargin: 6

        implicitWidth: 24 * Theme.fontSize
        implicitHeight: Math.min(columnLayout.implicitHeight + 40, parent.height * 0.5)

        color: Theme.addAlpha(Theme.colSurface, Theme.lightAlpha)

        radius: Theme.radius

        ColumnLayout {
            id: columnLayout
            anchors.fill: parent
            anchors.margins: Theme.fontEmphasizedSize
            spacing: Theme.fontMiniSize

            Text {
                text: "Power"
                color: Theme.colPrimary
                font { family: Theme.fontFamily; pointSize: Theme.fontEmphasizedSize; bold: true }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.colSurfaceContainer
            }

            Item {
                id: keyboardHandler
                Layout.fillWidth: true
                Layout.fillHeight: true
                implicitHeight: actionList.length * (Theme.fontSize * 3) + (actionList.length - 1) * Theme.fontMiniSize
                focus: visible

                Keys.onPressed: (event) => {
                    switch (event.key) {
                        case Qt.Key_Up:
                            root.selectedIndex = (root.selectedIndex - 1 + actionList.length) % actionList.length;
                            break;
                        case Qt.Key_Down:
                        case Qt.Key_Tab:
                            root.selectedIndex = (root.selectedIndex + 1) % actionList.length;
                            break;
                        case Qt.Key_Return:
                        case Qt.Key_Enter:
                            root.runAction(actionList[root.selectedIndex]);
                            break;
                        default:
                            const key = String.fromCharCode(event.key).toLowerCase();
                            const action = actionList.find(a => a.key === key);
                            if (action) {
                                root.runAction(action);
                            } else {
                                return;
                            }
                    }
                    event.accepted = true;
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.fontMiniSize

                    Repeater {
                        model: actionList

                        delegate: Item {
                            required property int index
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: Theme.fontSize * 3

                            Rectangle {
                                anchors.fill: parent
                                radius: Theme.radius
                                color: index === root.selectedIndex || hoverHandler.hovered ? Theme.colSurfaceContainer : "transparent"

                                Behavior on color { ColorAnimation { duration: 150; easing.type: Easing.OutQuad } }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 8
                                    spacing: Theme.fontSize

                                    Image {
                                        Layout.preferredWidth: Theme.fontSize * 2
                                        Layout.preferredHeight: Theme.fontSize * 2
                                        Layout.alignment: Qt.AlignVCenter
                                        source: modelData.icon
                                        sourceSize.width: 20
                                        sourceSize.height: 20
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter
                                        text: modelData.label
                                        color: modelData.danger === true ? Theme.colGreen : Theme.colOnSurfaceContainer
                                        font {
                                            family: Theme.fontFamily
                                            pointSize: Theme.fontSize
                                            bold: modelData.danger === true
                                        }
                                    }
                                }

                                HoverHandler {
                                    id: hoverHandler
                                    onHoveredChanged: {
                                        if (hovered) {
                                            root.selectedIndex = index;
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.runAction(modelData)
                                }
                            }
                        }
                    }
                }
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
