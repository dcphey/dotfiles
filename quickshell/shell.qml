import Quickshell
import QtQuick

import qs.modules
import qs.interfaces

ShellRoot {
    Variants {
        model: Quickshell.screens;

        delegate: Component {
            StatusBar {
                required property var modelData
                screen: modelData
            }
        }
    }

    AppMenu { }

    LockScreen {}
}
