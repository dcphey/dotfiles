import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.components.statusBar

RowLayout {
    spacing: 12

    property var screen

    readonly property var currentMonitor: screen ? Hyprland.monitorFor(screen) : null
    readonly property var filteredWorkspaces: {
        if (!currentMonitor) return [];
        return Hyprland.workspaces.values.filter(w => w.monitor?.name === currentMonitor?.name);
    }

    Repeater {
        model: parent.filteredWorkspaces.length
        HyprlandWorkspacePortal {
            required property int index
            workspaceId: parent.filteredWorkspaces[index].id
        }
    }
}
