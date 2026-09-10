pragma Singleton

import Quickshell
import QtQuick

Scope {
    property alias date: clock.date

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
