import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import ".."

NamePage {
    name: qsTr("Open Database")

    MessageDialog {
        id: removeDialog
        text: qsTr("Do you want to remove database?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.No) return
            database.remove(contextMenu.dbName)
            listView.model = database.list()
         }
    }

    ListView {
        id: listView
        anchors.fill: parent
        model: database.list()
        delegate: ItemDelegate {
            id: delegate
            width: ListView.view.width
            text: modelData

            onPressAndHold: {
                contextMenu.dbName = modelData
                contextMenu.popup(delegate)
            }

            onClicked: {
                database.open(modelData)
                openNodeTreeView()
            }
        }

        Menu {
            id: contextMenu
            property string dbName

            MenuItem {
                text: qsTr("Remove")
                onClicked: removeDialog.open()
            }
        }
    }
}
