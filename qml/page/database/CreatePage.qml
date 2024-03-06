import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Memo 1.0
import ".."

NamePage {
    name: qsTr("Create Database")

    Database {
        id: database
    }

    MessageDialog {
        id: overwriteDialog
        text: qsTr("File already exists")
        informativeText: qsTr("Do you want to overwrite it?")
        buttons: MessageDialog.Yes | MessageDialog.No
        onButtonClicked: function (button, role) {
            if (button === MessageDialog.Yes) {
                database.create(name.text)
            }
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width

        TextField {
            id: name
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("Name")
        }

        Button {
            Layout.alignment: Qt.AlignRight
            text: qsTr("OK")
            enabled: name.text
            onClicked: {
                if (database.isExists(name.text)) {
                    overwriteDialog.open()
                } else {
                    database.create(name.text)
                }
            }
        }
    }
}
