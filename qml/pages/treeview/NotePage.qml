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
            icon.source: "qrc:/assets/icons/edit.svg"
            visible: !editMode

            onClicked: {
                editMode = true
                textArea.forceActiveFocus()
            }
        }

        ToolButton {
            icon.source: "qrc:/assets/icons/device-floppy.svg"
            visible: editMode

            onClicked: {
                database.updateNoteValue(id, "note", textArea.text)
                editMode = false
                textArea.forceActiveFocus()
            }
        }

        ToolButton {
            icon.source: "qrc:/assets/icons/cancel.svg"
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
