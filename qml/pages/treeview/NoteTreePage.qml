import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQml.Models
import Memo
import "../../components"
import ".."

NamedPage {
    id: root
    readonly property bool isTreeView: true
    name: database.name

    toolBar: Row {
        ToolButton {
            icon.source: "qrc:/assets/icons/square-plus.svg"

            onClicked: {
                addNoteDialog.name = ""
                addNoteDialog.show()
            }
        }

        ToolButton {
            icon.source: "qrc:/assets/icons/deselect.svg"
            enabled: treeView.selectionModel.currentIndex.valid
            onClicked: treeView.selectionModel.clear()
        }
    }

    Component.onCompleted: treeModel.insertNotes()

    function clearSelection() {
        treeView.selectionModel.clearCurrentIndex()
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
            implicitWidth: treeView.width

            TapHandler {
                onTapped: {
                    const index = treeView.index(row, column)
                    treeView.selectionModel.setCurrentIndex(index, ItemSelectionModel.ClearAndSelect)
                }

                onLongPressed: {
                    const index = treeView.index(row, column)
                    treeView.selectionModel.setCurrentIndex(index, ItemSelectionModel.ClearAndSelect)
                    contextMenu.popup(delegate)
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
}
