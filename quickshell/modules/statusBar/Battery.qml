import QtQuick

import Quickshell.Services.UPower

import qs
import qs.assets
import qs.components.statusBar

TrayImage {
    iconSource: UPower.onBattery ? Assets.battery : Assets.batteryCharge
    iconColor: UPower.onBattery ? Theme.colOnSurface : Theme.colGreen
    widthCoefficient: 3.5
    heightCoefficient: 3.5

    Text {
        anchors.centerIn: parent
        text: Math.round(UPower.displayDevice.percentage * 100)
        color: Theme.colOnSurface
        font { family: Theme.fontFamily; pointSize: Theme.fontMiniSize; bold: true }
        width: parent.width - 1
        horizontalAlignment: Text.AlignHCenter
    }
}
