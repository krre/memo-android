import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Memo 1.0
import ".."

NamePage {
    name: qsTr("Create Database")

    Database {
        id: database
    }

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
            onClicked: database.create(name.text)
        }
    }
}
