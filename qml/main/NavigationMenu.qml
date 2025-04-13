import QtQuick
import QtQuick.Controls

Drawer {
    id: root

    Column {
        anchors.fill: parent

        ItemDelegate {
            width: parent.width
            visible: database.isOpen
            text: qsTr("Close")

            onClicked: {
                database.close()
                stackView.clear()
                stackView.push(databasePageComp)
                root.close()
            }
        }

        ItemDelegate {
            width: parent.width
            text: qsTr("Exit")

            action: Action {
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
    }
}
