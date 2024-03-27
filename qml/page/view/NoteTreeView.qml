import QtQuick
import QtQuick.Controls
import ".."

NamePage {
    id: root
    name: database.name
    buttons: [ addButtonComp.createObject() ]

    Component {
        id: addButtonComp

        ToolButton {
            text: "Add"
            onClicked: nameDialog.open()
        }
    }

    Dialog {
        id: nameDialog
        title: qsTr("Add Note")
        anchors.centerIn: parent
        width: root.width * 0.8
        parent: Overlay.overlay
        focus: true
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: {
            if (!name.text) return
            print(name.text)
        }

        TextField {
            id: name
            focus: true
            placeholderText: qsTr("Name")
            width: parent.width
        }
    }
}
