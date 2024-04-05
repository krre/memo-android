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
            icon.name: "edit"
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
