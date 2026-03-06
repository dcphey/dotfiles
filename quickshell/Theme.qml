pragma Singleton

import QtQuick

QtObject {
    // Color Scheme
    property color colSurface: "#242424"
    property color colOnSurface: "#fafafa"

    property color colSurfaceContainer: "#484848"
    property color colOnSurfaceContainer: "#fafafa"

    property color colPrimary: "#eeeeee"
    property color colOnPrimary: "#242424"
    property color colPrimaryVariant: "#c2c2c2"
    property color colOnPrimaryVariant: "#242424"

    property color colSecondary: "#808080"
    property color colOnSecondary: "#242424"
    property color colSecondaryVariant: "#606060"
    property color colOnSecondaryVariant: "#fafafa"

    property color colTertiary: "#333333"
    property color colOnTertiary: "#fafafa"
    property color colTertiaryVariant: "#1d1d1d"
    property color colOnTertiaryVariant: "#fafafa"

    property color colGreen: "#97ccbe"
    property color colBlue: "#55a2bb"

    property color colShadow: "#000000"

    // Color Alpha Scheme
    property real lightAlpha: 0.6
    property real lightShadowAlpha: 0.1

    // Font Base
    property string fontFamily: "Montserrat"
    property real fontSize: 12
    property real fontMiniSize: 8
    property real fontEmphasizedSize: 16

    //property string iconFontFamily: "Font Awesome 7 Free"

    // Rounded Corner
    property int radius: 10

    // Functions
    function addAlpha(base, alpha) {
        return Qt.rgba(base.r, base.g, base.b, alpha)
    }
}
