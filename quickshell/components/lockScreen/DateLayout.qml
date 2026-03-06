import Quickshell
import QtQuick
import QtQuick.Layouts

import qs

Text {
    required property var systemClock

    color: Theme.colOnSurface
    text: Qt.formatDateTime(systemClock.date, "yyyy.MM.dd (ddd)")
    font { family: Theme.fontFamily; pointSize: Theme.fontEmphasizedSize; }
}
