pragma Singleton

import QtQuick

QtObject {
    property string clipCopy: Qt.resolvedUrl("ClipCopy.sh").toString().replace("file://","")
    property string clipListWithImages: Qt.resolvedUrl("ClipListWithImages.sh").toString().replace("file://","")
}
