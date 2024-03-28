import QtQuick
import QtQuick.Controls
import QtQml.Models
import Memo 1.0
import ".."

NamePage {
    id: root
    name: database.name
    buttons: [ addButtonComp.createObject() ]

    Component {
        id: addButtonComp

        ToolButton {
            text: "Add"
            onClicked: {
                nameDialog.open()
                name.clear()
                name.forceActiveFocus()
            }
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
        }

        TextField {
            id: name
            placeholderText: qsTr("Name")
            width: parent.width
        }
    }

    TreeModel {
        id: treeModel
    }

    TreeView {
        id: treeView
        anchors.fill: parent
        model: treeModel
    }
}
