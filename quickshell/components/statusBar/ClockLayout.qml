import Quickshell
import QtQuick
import QtQuick.Layouts

import qs

RowLayout {
    required property var systemClock
    spacing: 0

    component EmphasizedDigit: Text {
        property real widthCoefficient: 2

        Layout.preferredWidth: Theme.fontEmphasizedSize * this.widthCoefficient
        color: Theme.colOnSurface
        font { family: Theme.fontFamily; pointSize: Theme.fontEmphasizedSize; }
    }

    component Digit: Text {
        property real widthCoefficient: 2.5

        Layout.preferredWidth: Theme.fontSize * this.widthCoefficient
        Layout.alignment: Qt.AlignTop
        color: Theme.colOnSurface
        font { family: Theme.fontFamily; pointSize: Theme.fontSize; }
    }

    Digit {
        text: Qt.formatDateTime(systemClock.date, "MM") + ". "
    }

    EmphasizedDigit {
        text: Qt.formatDateTime(systemClock.date, "dd")
    }

    EmphasizedDigit {
        text: Qt.formatDateTime(systemClock.date, "HH")
    }

    Digit {
        text: ": " + Qt.formatDateTime(systemClock.date, "mm")
    }

    /*Digit {
        text: ": " + Qt.formatDateTime(systemClock.date, "ss")
    }*/
}
