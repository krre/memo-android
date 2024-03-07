import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

NamePage {
    name: qsTr("Connect to Database")

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width
        spacing: 10

        TextField {
            id: ip
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("IP address")
            focus: true
        }

        TextField {
            id: port
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("Port")
        }

        TextField {
            id: token
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("Token")
        }

        Button {
            Layout.alignment: Qt.AlignRight
            text: qsTr("OK")
            enabled: ip.text && port.text && token.text
            onClicked: openNodeTreeView()
        }
    }
}
