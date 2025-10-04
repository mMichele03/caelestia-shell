pragma ComponentBehavior: Bound

import qs.components.effects
import qs.services
import qs.config
import qs.utils
import Quickshell.Services.SystemTray
import QtQuick

MouseArea {
    id: root

    required property SystemTrayItem modelData

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: Appearance.font.size.small * 2
    implicitHeight: Appearance.font.size.small * 2

    onClicked: event => {
        if (event.button === Qt.LeftButton) {
            for (const sub of Config.bar.tray.iconSubs) {
                if ((!modelData.id.startsWith(sub.id) && !modelData.tooltipTitle.startsWith(sub.tooltipTitle)) || !sub.activate)
                    continue;

                // If a class is configured for this icon substitution, check existing toplevels
                // and, if a class is specified, focus the first matching window instead of launching a new one.
                try {
                    if (sub.class) {
                        var tls = Hypr.toplevels.values.filter(c => c.lastIpcObject?.class === sub.class);

                        if (tls.length > 0) {
                            Hypr.dispatch(`focuswindow class:${sub.class}`);
                        } else {
                            Hypr.dispatch(`exec ${sub.activate}`);
                        }
                    } else {
                        Hypr.dispatch(`exec ${sub.activate}`);
                    }
                } catch (e) {
                    // If anything goes wrong reading toplevels, fall back to exec below
                    console.warn("TrayItem: failed to check Hypr.toplevels", e);
                }
                return;
            }
            modelData.activate();
        } else {
            modelData.secondaryActivate();
        }
    }

    ColouredIcon {
        id: icon

        anchors.fill: parent
        source: Icons.getTrayIcon(root.modelData.id, root.modelData.icon)
        colour: Colours.palette.m3secondary
        layer.enabled: Config.bar.tray.recolour
    }
}
