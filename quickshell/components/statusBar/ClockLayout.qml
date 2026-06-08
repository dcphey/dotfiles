import Quickshell
import QtQuick
import QtQuick.Layouts

import qs
import qs.modules.utilities

RowLayout {
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
        text: Qt.formatDateTime(Clock.date, "MM") + ". "
    }

    EmphasizedDigit {
        text: Qt.formatDateTime(Clock.date, "dd")
    }

    EmphasizedDigit {
        text: Qt.formatDateTime(Clock.date, "HH")
    }

    Digit {
        text: ": " + Qt.formatDateTime(Clock.date, "mm")
    }

    /*Digit {
        text: ": " + Qt.formatDateTime(Clock.date, "ss")
    }*/
}
