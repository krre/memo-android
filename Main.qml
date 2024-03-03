import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "page/database"

ApplicationWindow {
    width: 400
    height: 770
    visible: true
    title: "Memo"

    Component.onCompleted: {
        x = (Screen.desktopAvailableWidth - width) /2
        y = (Screen.desktopAvailableHeight - height) /2
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            Label {
                id: title
                text: stackView.currentItem.name
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: DatabasePage {}
    }
}
