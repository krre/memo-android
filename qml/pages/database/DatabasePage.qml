import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

NamedPage {
    name: qsTr("Database")

    ColumnLayout {
        anchors.centerIn: parent

        Button {
            text: qsTr("Create")
            Layout.fillWidth: true
            onClicked: pushPage(createPageComp)

            Component {
                id: createPageComp
                CreateDatabasePage {}
            }
        }

        Button {
            text: qsTr("Open")
            Layout.fillWidth: true
            onClicked: pushPage(openPageComp)

            Component {
                id: openPageComp
                OpenPage {}
            }
        }

        Button {
            text: qsTr("Connect")
            Layout.fillWidth: true
            onClicked: pushPage(connectPageComp)

            Component {
                id: connectPageComp
                ConnectPage {}
            }
        }
    }
}
