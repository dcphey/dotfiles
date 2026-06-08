import Quickshell
import QtQuick
import QtQuick.Layouts

import qs
import qs.modules.utilities

Text {
    color: Theme.colOnSurface
    text: Qt.formatDateTime(Clock.date, "yyyy.MM.dd (ddd)")
    font { family: Theme.fontFamily; pointSize: Theme.fontEmphasizedSize; }
}
