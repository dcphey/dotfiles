pragma Singleton

import QtQuick

QtObject {
    property string drunParser: Qt.resolvedUrl("DrunParser.sh").toString().replace("file://","")
}
