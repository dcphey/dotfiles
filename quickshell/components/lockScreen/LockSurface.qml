import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Wayland

import qs
import qs.components.lockScreen
import qs.modules.lockScreen

Rectangle {
	id: root
	required property LockContext context

	color: "transparent"

	anchors.fill: parent

	Image {
	    id: background
	    source: "/home/daniel/.config/hypr/bg/desktop.png"
	    anchors.fill: parent

	}

	MultiEffect {
   	    source: background
  		anchors.fill: background

  		brightness: -0.2
    }

    Image {
   	    property real xScale: background.sourceSize.width / background.width
  		property real yScale: background.sourceSize.height / background.height

   	    id: clippedBackground

  		source: background.source

        width: parent.width * 0.39
        height: parent.height * 0.33

        anchors.verticalCenter: background.verticalCenter
        anchors.left: background.left

  		anchors.leftMargin: parent.width * 0.02

   	    sourceClipRect: Qt.rect(x * xScale, y * yScale, width * xScale, height * yScale)

        layer.enabled: true
        layer.effect: MultiEffect {
            colorization: Theme.lightShadowAlpha
            colorizationColor: Theme.colShadow

            blurEnabled: true
            blur: 1.0
            blurMax: 52
            blurMultiplier: 1.25

            autoPaddingEnabled: false

            maskEnabled: true
            maskSource: mask
        }
   	}

    Rectangle {
        id: mask
        width: clippedBackground.width
        height: clippedBackground.height
        radius: Theme.radius
        layer.enabled: true
        visible: false
    }

    RectangularShadow {
        anchors.fill: clippedBackground
        color: Theme.addAlpha(Theme.colShadow, Theme.lightShadowAlpha)
        blur: 3
        spread: 3
        radius: Theme.radius
    }


	ColumnLayout {
		// Uncommenting this will make the password entry invisible except on the active monitor.
		// visible: Window.active

		anchors.top: clippedBackground.top
		anchors.left: clippedBackground.left
		anchors.margins: clippedBackground.width * 0.05

		Clock { }
		Date { }

		TextField {
			id: passwordBox

			focus: true
			enabled: !root.context.unlockInProgress
			echoMode: TextInput.Password
			inputMethodHints: Qt.ImhSensitiveData

			// Update the text in the context when the text in the box changes.
			onTextChanged: root.context.currentText = this.text;

			// Try to unlock when enter is pressed.
			onAccepted: root.context.tryUnlock();

			// Update the text in the box to match the text in the context.
			// This makes sure multiple monitors have the same text.
			Connections {
				target: root.context

				function onCurrentTextChanged() {
					passwordBox.text = root.context.currentText;
				}
			}

			// Styling
			background: Rectangle {
			    color: Theme.addAlpha(Theme.colOnSurface, Theme.lightAlpha)
                radius: Theme.radius
			}
			color: Theme.colSurfaceContainer
		    padding: Theme.fontSize
			implicitWidth: clippedBackground.width * 0.5
			placeholderText: "Password"
			font { family: Theme.fontFamily; pointSize: Theme.fontMiniSize; }
		}

		Label {
			visible: root.context.showFailure
			text: "Incorrect password"
			color: Theme.colOnSurface
			font { family: Theme.fontFamily; pointSize: Theme.fontSize; }
		}
	}
}
