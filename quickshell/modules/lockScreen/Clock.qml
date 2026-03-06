import Quickshell
import QtQuick
import QtQuick.Layouts

import qs
import qs.components.lockScreen

RowLayout {
    ClockLayout {
        systemClock: systemClock
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Seconds
    }
}
