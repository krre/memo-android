import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

NamePage {
    name: qsTr("Database")
    isInitialPage: true

    ColumnLayout {
        anchors.centerIn: parent

        Button {
            text: qsTr("Create")
            onClicked: pushPage(createPageComp)

            Component {
                id: createPageComp
                CreatePage {}
            }
        }

        Button {
            text: qsTr("Open")
            onClicked: pushPage(openPageComp)

            Component {
                id: openPageComp
                OpenPage {}
            }
        }

        Button {
            text: qsTr("Connect")
            onClicked: pushPage(connectPageComp)

            Component {
                id: connectPageComp
                ConnectPage {}
            }
        }
    }
}
