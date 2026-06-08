import Quickshell
import QtQuick
import QtQuick.Layouts

import qs
import qs.modules.utilities

RowLayout {
    property real fontScale: 5
    spacing: 0

    component EmphasizedDigit: Text {
        property real widthCoefficient: 7.5

        Layout.preferredWidth: Theme.fontEmphasizedSize * this.widthCoefficient
        color: Theme.colOnSurface
        font { family: Theme.fontFamily; pointSize: Theme.fontEmphasizedSize * parent.fontScale; }
    }

    component Digit: Text {
        property real widthCoefficient: 7.5

        Layout.preferredWidth: Theme.fontSize * this.widthCoefficient
        Layout.alignment: Qt.AlignTop
        color: Theme.colOnSurface
        font { family: Theme.fontFamily; pointSize: Theme.fontSize * parent.fontScale; }
    }

    EmphasizedDigit {
        text: Qt.formatDateTime(Clock.date, "HH")
    }

    Digit {
        text: " :" + Qt.formatDateTime(Clock.date, "mm")
    }
}
