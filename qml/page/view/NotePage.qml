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
            icon.name: "save"
            onClicked: {
                database.updateNoteValue(id, "note", textArea.text)
                editMode = false
            }
        }
    }

    Component {
        id: cancelButtonComp

        ToolButton {
            icon.name: "cancel"
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
