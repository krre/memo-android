import QtQuick
import QtQuick.Controls
import QtQml.Models
import Memo 1.0
import ".."

NamePage {
    id: root
    name: database.name
    buttons: [ addButtonComp.createObject() ]

    function addNote(title) {
        treeModel.insertRow(0)

        let child = treeModel.index(0, 0)
        treeModel.setData(child, title);
    }

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
            if (name.text) {
                addNote(name.text)
            }
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
        selectionModel: ItemSelectionModel {}
        delegate: TreeViewDelegate {}
    }

    MouseArea {
        anchors.fill: parent

        onPressed: (mouse) => {
            mouse.accepted = false
            const pos = treeView.cellAtPosition(mouseX, mouseY)

            if (pos.x === -1 && pos.y === - 1) {
                treeView.selectionModel.clearCurrentIndex()
            }
        }
    }
}
