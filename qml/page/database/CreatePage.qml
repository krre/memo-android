import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

NamePage {
    name: qsTr("Create Database")

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width

        TextField {
            id: name
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("Name")
        }

        Button {
            Layout.alignment: Qt.AlignRight
            text: qsTr("OK")
            enabled: name.text
            onClicked: print(name.text)
        }
    }
}
