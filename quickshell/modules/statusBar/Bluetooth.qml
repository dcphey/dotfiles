import QtQuick
import QtQuick.Layouts

import Quickshell.Bluetooth

import qs
import qs.assets
import qs.components.statusBar

RowLayout {
    property int connected: Bluetooth.devices.values.filter(d => d.connected).length

    TrayImage {
        iconSource: parent.connected > 0 ? Assets.bluetooth : Assets.bluetoothConnected
        iconColor: parent.connected > 0 ? Theme.colBlue : Theme.colOnSurface
        heightCoefficient: 2.5
        widthCoefficient: 2.5
    }

    Text {
        Layout.preferredWidth: Theme.fontMiniSize * 2
        horizontalAlignment: Text.AlignHCenter
        text: parent.connected > 0 ? parent.connected : ""
        color: Theme.colOnSurface
        font { family: Theme.fontFamily; pointSize: Theme.fontMiniSize; bold: true }
    }
}
