import QtQuick
import QtQuick.Layouts

import Quickshell.Networking
import Quickshell.Io

import qs
import qs.assets
import qs.components.statusBar

RowLayout {
    Repeater {
        model: Networking.devices.values.length
        RowLayout {
            required property int index
            TrayImage {
                property var dev: Networking.devices.values

                iconSource: dev[index].type === DeviceType.Wifi ?
                    (dev[index].connected ? Assets.wifi : Assets.wifiOff):
                    (dev[index].connected ? Assets.plugConnected : Assets.plugDisconnected)
                iconColor: dev[index].connected ? Theme.colBlue : Theme.colOnSurface
                widthCoefficient: 3
                heightCoefficient: 3
            }

            Text {
                id: bandWidth
                Layout.preferredWidth: Theme.fontMiniSize * 8
                horizontalAlignment: Text.AlignHCenter
                text: "0.00 B/s"
                color: Theme.colOnSurface
                font { family: Theme.fontFamily; pointSize: Theme.fontMiniSize; bold: true }
            }

            property var prevTime: Date.now()
            property real prevValue: 0
            property string name: Networking.devices.values[index].name

            Process {
                id: bandWidthProcess

                command: ["sh", "-c", `(cat /sys/class/net/${name}/statistics/rx_bytes; cat /sys/class/net/${name}/statistics/tx_bytes)`]
                stdout: StdioCollector {
                    onStreamFinished: () => {
                        const p = text.trim().split(/\s+/);
                        const currentTime = Date.now();
                        const currentValue = Number(p[0]) + Number(p[1])
                        const units = ["", "K", "M", "G", "T"]

                        if (prevValue > 0) {
                            let delta = (currentValue - prevValue) / (currentTime - prevTime) *  1000;
                            for (const u of units) {
                                const newDelta = delta / 1024;
                                if (newDelta < 1) {
                                    bandWidth.text = `${delta.toFixed(2)} ${u}B/s`;
                                    break;
                                }
                                else {
                                    delta = newDelta;
                                }

                            }
                        }
                        prevTime = currentTime;
                        prevValue = currentValue;
                    }
                }

                running: true
            }

            Timer {
                // 5000 milliseconds is 5 seconds
                interval: 5000

                // start the timer immediately
                running: true

                // run the timer again when it ends
                repeat: true

                // when the timer is triggered, set the running property of the
                // process to true, which reruns it if stopped.
                onTriggered: bandWidthProcess.running = true
            }
        }
    }
}
