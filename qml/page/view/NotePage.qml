import QtQuick
import QtQuick.Controls
import ".."

NamePage {
    id: root
    required property int id
    required property string note
    property bool editMode: false
    toolBar: Row {
        ToolButton {
            icon.name: "edit"
            visible: !editMode
            onClicked: {
                textArea.forceActiveFocus()
                editMode = true
            }
        }

        ToolButton {
            icon.name: "save"
            visible: editMode
            onClicked: {
                database.updateNoteValue(id, "note", textArea.text)
                editMode = false
            }
        }

        ToolButton {
            icon.name: "cancel"
            visible: editMode
            onClicked: {
                textArea.text = database.noteValue(id, "note")
                editMode = false
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
