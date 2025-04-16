import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../../components"
import ".."

NamedPage {
    name: qsTr("Create Database")

    function create(name) {
        database.create(name)
        openNodeTreeView()
    }

    MessageDialog {
        id: overwriteDialog
        text: qsTr("File already exists")
        informativeText: qsTr("Do you want to overwrite it?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.Yes) {
                create(name.text)
            }
        }
    }

    ColumnLayout {
        width: parent.width

        TextField {
            id: name
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("Name")
            focus: true
        }

        OkButton {
            Layout.alignment: Qt.AlignRight
            enabled: name.text

            onClicked: {
                if (database.isExists(name.text)) {
                    overwriteDialog.open()
                } else {
                    create(name.text)
                }
            }
        }
    }
}
