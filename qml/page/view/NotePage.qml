import QtQuick
import QtQuick.Controls
import ".."

NamePage {
    id: root
    required property string note

    TextArea {
        anchors.fill: parent
        text: note
        focus: true
        readOnly: true
    }
}
