import QtQuick
import QtQuick.Controls

Dialog {
    property alias name: name.text
    anchors.centerIn: parent
    width: root.width * 0.8
    parent: Overlay.overlay
    focus: true
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    function show() {
        name.forceActiveFocus()
        open()
    }

    TextField {
        id: name
        placeholderText: qsTr("Name")
        width: parent.width
    }
}
