import QtQuick
import QtQuick.Controls
import ".."

NamePage {
    id: root
    required property int id
    required property string note
    property bool editMode: false

    Component.onCompleted: textArea.forceActiveFocus()

    toolBar: Row {
        ToolButton {
            icon.name: "edit"
            visible: !editMode
            onClicked: {
                editMode = true
                textArea.forceActiveFocus()
            }
        }

        ToolButton {
            icon.name: "save"
            visible: editMode
            onClicked: {
                database.updateNoteValue(id, "note", textArea.text)
                editMode = false
                textArea.forceActiveFocus()
            }
        }

        ToolButton {
            icon.name: "cancel"
            visible: editMode
            onClicked: {
                textArea.text = database.noteValue(id, "note")
                editMode = false
                textArea.forceActiveFocus()
            }
        }
    }

    ScrollView {
        anchors.fill: parent

        TextArea {
            id: textArea
            text: note
            wrapMode: Text.WordWrap
            readOnly: !editMode
        }
    }
}
