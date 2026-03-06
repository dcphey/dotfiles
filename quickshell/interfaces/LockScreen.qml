import Quickshell
import Quickshell.Wayland
import Quickshell.Io

import QtQuick

import qs.modules.lockScreen
import qs.components.lockScreen

Scope {
	IpcHandler {
		target: "lock"
			function triggerLock(): void {
				if (lock.locked)
					return;
				lock.locked = true;
			}
	}
	// This stores all the information shared between the lock surfaces on each screen.
	LockContext {
		id: lockContext

		onUnlocked: {
			// Unlock the screen before exiting, or the compositor will display a
			// fallback lock you can't interact with.
			lock.locked = false;

			//Qt.quit();
		}
	}

	WlSessionLock {
		id: lock

		// Lock the session immediately when quickshell starts.
		locked: false

		WlSessionLockSurface {
			LockSurface {
				context: lockContext
			}
		}

    }
}
