import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.components.statusBar

// Workspaces
RowLayout {
    spacing: 12

    Repeater {
        model: Hyprland.workspaces.values.length
        HyprlandWorkspacePortal {
            required property int index
            workspaceId: Hyprland.workspaces.values[index].id
        }
    }
}
