pragma Singleton

import QtQuick

QtObject {
    property string drunParser: Qt.resolvedUrl("DrunParser.sh").toString().replace("file://","")
    property string iconResolver: Qt.resolvedUrl("IconResolver.sh").toString().replace("file://","")
    property string desktopWatcher: Qt.resolvedUrl("DesktopWatcher.sh").toString().replace("file://","")
    property bool menuVisible: false
}
