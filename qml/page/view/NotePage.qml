import QtQuick
import QtQuick.Controls
import ".."

NamePage {
    id: root
    required property int id
    required property string note
    property bool editMode: false
    buttons: editMode ? [ saveButtonComp.createObject(), cancelButtonComp.createObject() ] : [ editButtonComp.createObject() ]

    Component {
        id: editButtonComp

        ToolButton {
            text: "Edit"
            onClicked: {
                textArea.forceActiveFocus()
                editMode = true
            }
        }
    }

    Component {
        id: saveButtonComp

        ToolButton {
            text: "Save"
            onClicked: {
                database.updateNoteValue(id, "note", textArea.text)
                editMode = false
            }
        }
    }

    Component {
        id: cancelButtonComp

        ToolButton {
            text: "Cancel"
            onClicked: {
                textArea.text = database.noteValue(id, "note")
                editMode = false
            }
        }
    }

    TextArea {
        id: textArea
        anchors.fill: parent
        text: note
        readOnly: !editMode
    }
}
