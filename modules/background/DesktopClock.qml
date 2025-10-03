import qs.components
import qs.services
import qs.config
import QtQuick

Item {
    implicitWidth: timeText.implicitWidth + Appearance.padding.large * 2
    implicitHeight: timeText.implicitHeight + Appearance.padding.large * 2

    StyledText {
        id: timeText

        anchors.centerIn: parent
        text: Time.format(`${Config.background.desktopClock.timeFormat}${Config.services.useTwelveHourClock ? " A" : ""}`)
        font.pointSize: Appearance.font.size.extraLarge
        font.bold: true
    }
}
