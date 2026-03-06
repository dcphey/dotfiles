import Quickshell.Hyprland
import QtQuick

import qs

Rectangle {
    // Properties
    required property int workspaceId
    property bool isActive: Hyprland.focusedWorkspace?.id === this.workspaceId
    property bool isUrgent: Hyprland.workspaces.values.find(e => e.id == this.workspaceId).urgent

    // Appearance
    color: this.isActive ?
        (hoverHandler.hovered ? Theme.colPrimaryVariant : Theme.colPrimary) :
        this.isUrgent ?
        (hoverHandler.hovered ? Theme.colTertiaryVariant : Theme.colTertiary):
        (hoverHandler.hovered ? Theme.colSecondaryVariant : Theme.colSecondary)

    implicitHeight: Theme.fontMiniSize
    implicitWidth: Theme.fontSize * (this.isActive ? 4 : 2)

    radius: Theme.radius

    // Animations
    Behavior on color { ColorAnimation { duration: 150; easing.type: Easing.OutQuad } }

    Behavior on implicitWidth { NumberAnimation { duration: 150; easing.type: Easing.OutQuad} }

    // Interactions
    MouseArea {
        //anchors.fill: parent
        anchors.centerIn: parent
        width: parent.width
        height: parent.height * 3
        onClicked: Hyprland.dispatch(`workspace ${parent.workspaceId}`);

        HoverHandler {
            id: hoverHandler
        }
    }
}
