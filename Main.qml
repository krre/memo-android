import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: 400
    height: 770
    visible: true
    title: "Memo"

    Component.onCompleted: {
        x = (Screen.desktopAvailableWidth - width) /2
        y = (Screen.desktopAvailableHeight - height) /2
    }
}
