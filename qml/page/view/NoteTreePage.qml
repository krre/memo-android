import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQml.Models
import Memo 1.0
import ".."

NamePage {
    id: root
    name: database.name
    buttons: [ addButtonComp.createObject() ]

    Component.onCompleted: treeModel.insertNotes()

    Component {
        id: addButtonComp

        ToolButton {
            icon.name: "add_box"
            onClicked: {
                addNoteDialog.name = ""
                addNoteDialog.show()
            }
        }
    }

    Component {
        id: notePageComp
        NotePage {}
    }

    NameDialog {
        id: addNoteDialog
        title: qsTr("Add Note")

        onAccepted: {
            if (!name) return

            const noteIndex = treeModel.insertNote(treeView.selectionModel.currentIndex, name)
            treeView.selectionModel.setCurrentIndex(noteIndex, ItemSelectionModel.ClearAndSelect)

            treeView.expandToIndex(noteIndex)
            treeView.forceLayout()
            treeView.positionViewAtRow(treeView.rowAtIndex(noteIndex), Qt.AlignVCenter)
        }
    }

    NameDialog {
        id: renameNoteDialog
        title: qsTr("Rename Note")

        onAccepted: {
            if (!name) return
            treeModel.renameNote(treeView.selectionModel.currentIndex, name)
        }
    }

    MessageDialog {
        id: removeDialog
        text: qsTr("Do you want to remove note?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onButtonClicked: function (button, role) {
            if (button === MessageDialog.No) return
            treeModel.removeNote(treeView.selectionModel.currentIndex)
         }
    }

    TreeModel {
        id: treeModel
        database: database
    }

    TreeView {
        id: treeView
        anchors.fill: parent
        model: treeModel
        selectionModel: ItemSelectionModel {}
        delegate: TreeViewDelegate {
            id: delegate

            // Android case for production.
            onPressAndHold: contextMenu.open()

            // Desktop case for developing.
            TapHandler {
                acceptedButtons: Qt.RightButton
                onSingleTapped: (eventPoint, button) => {
                    if (button !== Qt.RightButton) return

                    const rootPos = delegate.mapToItem(root, eventPoint.position)

                    contextMenu.x = rootPos.x
                    contextMenu.y = rootPos.y

                    contextMenu.open()
                }
            }
        }

        Menu {
            id: contextMenu

            MenuItem {
                text: qsTr("Open")
                onClicked: {
                    const note = treeModel.note(treeView.selectionModel.currentIndex)
                    pushPage(notePageComp, { "name": note.title, "id": note.id, "note": note.note })
                }
            }

            MenuItem {
                text: qsTr("Rename")
                onClicked: {
                    renameNoteDialog.name = treeModel.note(treeView.selectionModel.currentIndex).title
                    renameNoteDialog.show()
                }
            }

            MenuItem {
                text: qsTr("Remove")
                onClicked: removeDialog.open()
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onPressed: (mouse) => {
            mouse.accepted = false
            const cell = treeView.cellAtPosition(mouseX, mouseY)

            if (cell.x === -1 && cell.y === - 1) {
                treeView.selectionModel.clearCurrentIndex()
            } else {
                const index = treeView.modelIndex(cell)
                treeView.selectionModel.setCurrentIndex(index, ItemSelectionModel.ClearAndSelect)

                contextMenu.x = mouseX
                contextMenu.y = mouseY
            }
        }
    }
}
