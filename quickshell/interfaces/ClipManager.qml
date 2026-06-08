import Quickshell
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import QtQuick.Controls
import Quickshell.Io

import Quickshell.Wayland

import qs
import qs.modules.clipManager

WlrLayershell {
    id: root
    layer: WlrLayer.Overlay
    visible: false
    keyboardFocus: WlrKeyboardFocus.OnDemand

    IpcHandler {
        target: "clipManager"
        function toggleMenu(): void {
            root.visible = !root.visible;
        }
    }

    property var clipItems: []
    property var filteredItems: []
    property string searchText: ""
    property int selectedIndex: 0

    onVisibleChanged: {
        if (visible) {
            clipItems = [];
            filteredItems = [];
            searchText = "";
            searchField.text = "";
            searchField.forceActiveFocus();
            cliphistProcess.running = false;
            cliphistProcess.running = true;
        }
    }

    onClipItemsChanged: filterItems()
    onSearchTextChanged: filterItems()
    onSelectedIndexChanged: {
        clipListView.positionViewAtIndex(selectedIndex, ListView.Contain);
    }

    function filterItems() {
        const q = searchText.toLowerCase().trim();
        if (!q) {
            filteredItems = clipItems;
            return;
        }
        filteredItems = clipItems.filter(item =>
            item.displayText.toLowerCase().includes(q)
        );
        selectedIndex = 0;
    }

    function copyItem(item) {
        if (!item) return;
        Quickshell.execDetached(["sh", ClipManagerAssets.clipCopy, item.id]);
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

    Process {
        id: cliphistProcess
        running: false
        command: ["sh", ClipManagerAssets.clipListWithImages]
        stdout: StdioCollector {
            onStreamFinished: () => {
                if (!text) return;
                const sep = '\x1f';
                const lines = text.trim().split('\n');
                const newItems = [];
                for (let i = 0; i < lines.length; i++) {
                    const line = lines[i].trim();
                    if (!line) continue;
                    const fields = line.split(sep);
                    if (fields[0] === 'I') {
                        const id = fields[1];
                        const mime = fields[2];
                        const displayText = fields[3];
                        const b64 = fields.slice(4).join(sep);
                        newItems.push({
                            isImage: true,
                            id: id,
                            displayText: "image",
                            imageSource: 'data:' + mime + ';base64,' + b64,
                        });
                    } else if (fields[0] === 'T') {
                        const id = fields[1];
                        const content = fields.slice(2).join(sep);
                        newItems.push({
                            isImage: false,
                            id: id,
                            displayText: content,
                        });
                    }
                }
                clipItems = newItems;
            }
        }
    }

    Rectangle {
        id: rect

        anchors.left: parent.left
        anchors.top: parent.top

        anchors.leftMargin: 6

        implicitWidth: 36 * Theme.fontSize
        implicitHeight: Math.min(columnLayout.implicitHeight + 40, parent.height * 0.6)

        color: Theme.addAlpha(Theme.colSurface, Theme.lightAlpha)

        radius: Theme.radius

        ColumnLayout {
            id: columnLayout
            anchors.fill: parent
            anchors.margins: Theme.fontEmphasizedSize
            spacing: Theme.fontMiniSize

            Text {
                text: "Clipboard"
                color: Theme.colPrimary
                font { family: Theme.fontFamily; pointSize: Theme.fontEmphasizedSize; bold: true }
            }

            TextField {
                id: searchField

                Layout.fillWidth: true

                color: Theme.colOnSurfaceContainer

                placeholderText: "Search clipboard history..."
                placeholderTextColor: Theme.colSecondary

                background: Rectangle {
                    radius: Theme.radius
                    color: Theme.addAlpha(Theme.colSurfaceContainer, Theme.lightAlpha)
                }

                font { family: Theme.fontFamily; pointSize: Theme.fontSize }

                leftPadding: 9
                rightPadding: 9
                topPadding: 6
                bottomPadding: 6

                onTextChanged: root.searchText = text
                onAccepted: {
                    if (filteredItems.length > 0 && root.selectedIndex < filteredItems.length) {
                        root.copyItem(filteredItems[root.selectedIndex]);
                    }
                }

                Keys.onPressed: (event) => {
                    switch (event.key) {
                        case Qt.Key_Up:
                            if (root.selectedIndex > 0) root.selectedIndex--;
                            break;
                        case Qt.Key_Down:
                        case Qt.Key_Tab:
                            if (root.selectedIndex < filteredItems.length - 1) root.selectedIndex++;
                            break;
                        case Qt.Key_PageUp:
                            root.selectedIndex = Math.max(0, root.selectedIndex - 10);
                            break;
                        case Qt.Key_PageDown:
                            root.selectedIndex = Math.min(filteredItems.length - 1, root.selectedIndex + 10);
                            break;
                        case Qt.Key_Home:
                            root.selectedIndex = 0;
                            break;
                        case Qt.Key_End:
                            root.selectedIndex = filteredItems.length - 1;
                            break;
                        default:
                            return;
                    }
                    event.accepted = true;
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.colSurfaceContainer
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    id: clipListView
                    model: filteredItems.length
                    spacing: Theme.fontSize * 0.6

                    delegate: Item {
                        required property int index
                        property var itemData: filteredItems[index]
                        width: parent ? parent.width : 0
                        height: itemData.isImage ? Theme.fontSize * 9 : Theme.fontSize * 3

                        Rectangle {
                            anchors.fill: parent
                            radius: Theme.radius
                            color: index === root.selectedIndex ? Theme.colSurfaceContainer : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: Theme.fontSize

                                Image {
                                    Layout.preferredHeight: itemData && itemData.isImage ? Theme.fontSize * 9 : 0
                                    Layout.preferredWidth: itemData && itemData.isImage ? Theme.fontSize * 9 : 0
                                    Layout.alignment: Qt.AlignVCenter
                                    source: itemData && itemData.isImage ? itemData.imageSource : ""
                                    sourceSize.width: Theme.fontSize * 9
                                    fillMode: Image.PreserveAspectFit
                                }

                                Text {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    text: itemData ? (itemData.isImage ? "" : itemData.displayText || "") : ""
                                    color: Theme.colOnSurfaceContainer
                                    elide: Text.ElideRight
                                    font {
                                        family: Theme.fontFamily
                                        pointSize: Theme.fontSize
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
                                onClicked: root.copyItem(itemData)
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
