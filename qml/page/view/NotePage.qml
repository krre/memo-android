import QtQuick
import QtQuick.Controls
import QtQml.Models
import QtQuick.Dialogs
import Memo 1.0
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
