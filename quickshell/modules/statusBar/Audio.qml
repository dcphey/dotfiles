import QtQuick
import QtQuick.Layouts

import Quickshell.Services.Pipewire

import qs
import qs.assets
import qs.components.statusBar

RowLayout {
    spacing: 0

    component Volume: Text {
        Layout.preferredWidth: Theme.fontMiniSize * 3
        horizontalAlignment: Text.AlignHCenter
        text: parent.muted ? "" : parent.volume
        color: Theme.colOnSurface
        font { family: Theme.fontFamily; pointSize: Theme.fontMiniSize; bold: true }
    }

    RowLayout {
        property var tracker: PwObjectTracker {objects: [Pipewire.defaultAudioSource]}
        property var source: Pipewire.defaultAudioSource
        property bool muted: source ? source.audio.muted : false
        property int volume: source ? Math.round(source.audio.volume * 100) : NaN
        property bool isBluetooth: source ? source.properties["node.name"].includes("bluez") : false

        spacing: 0

        TrayImage {
            iconSource: parent.muted ? Assets.micOff : Assets.mic
            iconColor: parent.isBluetooth ? Theme.colBlue : Theme.colOnSurface
            heightCoefficient: 2.5
            widthCoefficient: 2.5
        }

        Volume { }
    }

    RowLayout {
        property var tracker: PwObjectTracker {objects: [Pipewire.defaultAudioSink]}
        property var sink: Pipewire.defaultAudioSink
        property bool muted: sink ? sink.audio.muted : false
        property int volume: sink ? Math.round(sink.audio.volume * 100) : NaN
        property bool isBluetooth: sink ? sink.properties["node.name"].includes("bluez") : false

        spacing: 0

        TrayImage {
            iconSource: parent.muted ? Assets.speakerMute : (parent.isBluetooth ? Assets.speakerBluetooth : Assets.speaker)
            iconColor: parent.isBluetooth ? Theme.colBlue : Theme.colOnSurface
            heightCoefficient: 2.5
            widthCoefficient: 2.5
        }

        Volume { }
    }
}
