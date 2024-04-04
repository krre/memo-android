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
        const currentIndex = treeView.selectionModel.currentIndex
        const currentItem = treeModel.item(currentIndex)
        const currentId = currentItem.id()
        const pos = currentItem.childCount()
        const depth = currentItem.depth()
        const noteId = database.insertNote(currentId, pos, depth, title)

        if (!treeModel.insertRow(pos, currentIndex)) {
            return
        }

        const noteIndex = treeModel.index(pos, 0, currentIndex)
        treeModel.setData(noteIndex, title)
        treeModel.item(noteIndex).setId(noteId);

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
            const index = treeView.selectionModel.currentIndex
            const parentItem = treeModel.item(index.parent)

            for (let i = 0; i < parentItem.childCount(); i++) {
                const id = parentItem.child(i).id()
                database.updateNoteValue(id, "pos", i)
            }

            const item = treeModel.item(index)
            const ids = treeModel.childIds(item)
            treeModel.removeRow(index.row, index.parent)

            for (const id of ids) {
                database.removeNote(id)
            }
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
