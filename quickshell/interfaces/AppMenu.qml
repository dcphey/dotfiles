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
    id: root
    layer: WlrLayer.Overlay
    visible: AppMenuAssets.menuVisible
    keyboardFocus: WlrKeyboardFocus.OnDemand

    IpcHandler {
        target: "appMenu"
        function toggleMenu(): void {
            AppMenuAssets.menuVisible = !AppMenuAssets.menuVisible;
        }
    }

    property var cachedApps: []
    property string searchText: ""
    property var apps: []
    property int selectedIndex: 0
    property bool refreshPending: false

    onVisibleChanged: {
        if (visible) {
            searchText = "";
            searchField.text = "";
            searchField.forceActiveFocus();
        }
    }

    onCachedAppsChanged: filterApps()
    onSearchTextChanged: filterApps()
    onSelectedIndexChanged: {
        appListView.positionViewAtIndex(selectedIndex, ListView.Contain);
    }

    function filterApps() {
        const q = searchText.toLowerCase().trim();
        if (!q) {
            apps = cachedApps;
            return;
        }
        apps = cachedApps.filter(a =>
            (a.Name && a.Name.toLowerCase().includes(q)) ||
            (a.GenericName && a.GenericName.toLowerCase().includes(q)) ||
            (a.Keywords && a.Keywords.toLowerCase().includes(q))
        ).sort((a, b) => {
            function priority(app) {
                const name = (app.Name || '').toLowerCase();
                if (name.startsWith(q)) return 0;
                const generic = (app.GenericName || '').toLowerCase();
                if (generic.startsWith(q)) return 1;
                const keywords = (app.Keywords || '').toLowerCase();
                if (keywords.startsWith(q)) return 2;
                if (name.includes(q)) return 3;
                if (generic.includes(q)) return 4;
                if (keywords.includes(q)) return 5;
                return 6;
            }
            return priority(a) - priority(b);
        });
        selectedIndex = 0;
    }

    function refresh() {
        if (drunProcess.running) {
            refreshPending = true;
            return;
        }
        cachedApps = [];
        iconCache = ({});
        selectedIndex = 0;
        drunProcess.running = true;
    }

    function sanitizeExec(exec) {
        if (!exec) return "";
        let cmd = exec.replace(/%[uUfFdDnNickvm]/g, '').trim();
        cmd = cmd.replace(/%i/g, '').trim();
        return cmd;
    }

    function launchApp(app) {
        if (!app) return;
        const cmd = sanitizeExec(app.Exec);
        if (cmd) {
            const termFlag = app.Terminal === "true" ? "-T" : "";
            Quickshell.execDetached(["sh", "-c", `uwsm-app ${termFlag} -- ${cmd}`]);
        }
        AppMenuAssets.menuVisible = false;
    }

    Shortcut {
        sequence: "Escape"
        onActivated: AppMenuAssets.menuVisible = false
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
        onClicked: AppMenuAssets.menuVisible = false
    }

    property var iconCache: ({})

    function resolveIcons() {
        const seen = {};
        const names = [];
        for (let i = 0; i < cachedApps.length; i++) {
            const iconName = cachedApps[i].Icon;
            if (iconName && !seen[iconName]) {
                seen[iconName] = true;
                names.push(iconName);
            }
        }
        if (names.length === 0) return;
        iconProcess.exec(["sh", AppMenuAssets.iconResolver].concat(names));
    }

    Process {
        id: drunProcess
        running: true
        command: ["sh", AppMenuAssets.drunParser]
        stdout: SplitParser {
            onRead: (data) => {
                if (!data) return;
                const line = data.trim();
                if (!line) return;
                if (line === "__DRUN_END__") {
                    resolveIcons();
                    return;
                }
                const app = JSON.parse(line);
                cachedApps = [...cachedApps, app];
            }
        }
        onExited: {
            if (root.refreshPending) {
                root.refreshPending = false;
                root.refresh();
            }
        }
    }

    Process {
        id: iconProcess
        stdout: StdioCollector {
            onStreamFinished: () => {
                const map = {};
                const lines = text.trim().split('\n');
                for (let i = 0; i < lines.length; i++) {
                    const line = lines[i].trim();
                    if (!line) continue;
                    const sep = line.indexOf('|');
                    if (sep > 0) {
                        map[line.substring(0, sep)] = line.substring(sep + 1);
                    }
                }
                iconCache = map;
            }
        }
    }

    Process {
        id: watcherProcess
        running: true
        command: ["sh", AppMenuAssets.desktopWatcher]
        stdout: SplitParser {
            onRead: (data) => {
                if (data && data.trim()) root.refresh();
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
                text: "Apps"
                color: Theme.colPrimary
                font { family: Theme.fontFamily; pointSize: Theme.fontEmphasizedSize; bold: true }
            }

            TextField {
                id: searchField

                Layout.fillWidth: true

                color: Theme.colOnSurfaceContainer

                placeholderText: "Search apps..."
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
                    if (apps.length > 0 && root.selectedIndex < apps.length) {
                        root.launchApp(apps[root.selectedIndex]);
                    }
                }

                Keys.onPressed: (event) => {
                    switch (event.key) {
                        case Qt.Key_Up:
                            if (root.selectedIndex > 0) root.selectedIndex--;
                            break;
                        case Qt.Key_Down:
                        case Qt.Key_Tab:
                            if (root.selectedIndex < apps.length - 1) root.selectedIndex++;
                            break;
                        case Qt.Key_PageUp:
                            root.selectedIndex = Math.max(0, root.selectedIndex - 10);
                            break;
                        case Qt.Key_PageDown:
                            root.selectedIndex = Math.min(apps.length - 1, root.selectedIndex + 10);
                            break;
                        case Qt.Key_Home:
                            root.selectedIndex = 0;
                            break;
                        case Qt.Key_End:
                            root.selectedIndex = apps.length - 1;
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
                    id: appListView
                    model: apps.length
                    spacing: Theme.fontSize * 0.6

                    delegate: Item {
                        required property int index
                        property var appData: apps[index]
                        width: parent ? parent.width : 0
                        height: Theme.fontSize * 3

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
                                    Layout.preferredWidth: Theme.fontSize * 2
                                    Layout.preferredHeight: Theme.fontSize * 2
                                    source: {
                                        if (!appData) return ""
                                        var iconName = appData.Icon
                                        if (!iconName) return ""
                                        var path = iconCache[iconName] || ""
                                        return path ? "file://" + path : ""
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0

                                    Text {
                                        Layout.fillWidth: true
                                        text: appData ? appData.Name || "" : ""
                                        color: Theme.colOnSurfaceContainer
                                        elide: Text.ElideRight
                                        font { family: Theme.fontFamily; pointSize: Theme.fontSize }
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: appData ? appData.GenericName || appData.Comment || "" : ""
                                        color: Theme.addAlpha(Theme.colOnSurfaceContainer, Theme.lightAlpha)
                                        elide: Text.ElideRight
                                        font { family: Theme.fontFamily; pointSize: Theme.fontMiniSize }
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
                                onClicked: root.launchApp(appData)
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
