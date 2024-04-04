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

    function addNote(title) {
        const noteIndex = treeModel.insertNote(treeView.selectionModel.currentIndex, title)
        treeView.selectionModel.setCurrentIndex(noteIndex, ItemSelectionModel.ClearAndSelect)

        treeView.expandToIndex(noteIndex)
        treeView.forceLayout()
        treeView.positionViewAtRow(treeView.rowAtIndex(noteIndex), Qt.AlignVCenter)
    }

    function renameNote(title) {
        const noteIndex = treeView.selectionModel.currentIndex
        treeModel.setData(noteIndex, title)
        const item = treeModel.item(noteIndex)
        database.updateNoteValue(item.id(), "title", title)
    }

    Component {
        id: addButtonComp

        ToolButton {
            text: "Add"
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
            if (name) {
                addNote(name)
            }
        }
    }

    NameDialog {
        id: renameNoteDialog
        title: qsTr("Rename Note")

        onAccepted: {
            if (name) {
                renameNote(name)
            }
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
                    const currentIndex = treeView.selectionModel.currentIndex
                    const currentItem = treeModel.item(currentIndex)
                    const currentId = currentItem.id()
                    const note = database.note(currentId)

                    pushPage(notePageComp, { "name": note.title, "id": note.id, "note": note.note })
                }
            }

            MenuItem {
                text: qsTr("Rename")
                onClicked: {
                    const currentIndex = treeView.selectionModel.currentIndex
                    const currentItem = treeModel.item(currentIndex)
                    renameNoteDialog.name = currentItem.data()
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
