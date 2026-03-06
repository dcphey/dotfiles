import QtQuick
import QtQuick.Effects

import qs
import qs.assets
import qs.components.statusBar

Rectangle {
    TrayImage {
        iconSource: Assets.apps
        iconColor: hoverHandler.hovered ? Theme.colOnPrimaryVariant : Theme.colOnPrimary
        widthCoefficient: 2.5
        heightCoefficient: 2.5

        anchors.centerIn: parent
    }

    implicitWidth: Theme.fontSize * 2
    implicitHeight: Theme.fontSize * 2
    color: hoverHandler.hovered ? Theme.colPrimaryVariant : Theme.colPrimary
    radius: Theme.radius

    RectangularShadow {
        anchors.fill: parent
        color: Theme.addAlpha(Theme.colShadow, Theme.lightShadowAlpha)
        blur: 3
        spread: 3
        radius: Theme.radius
    }

    // Animations
    Behavior on color { ColorAnimation { duration: 150; easing.type: Easing.OutQuad } }

    // Interactions
    MouseArea {
        anchors.fill: parent
        anchors.centerIn: parent

        //onClicked: Hyprland.dispatch(`workspace ${parent.workspaceId}`);

        HoverHandler {
            id: hoverHandler
        }
    }
}
