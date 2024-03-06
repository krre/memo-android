import QtQuick
import QtQuick.Controls
import ".."

NamePage {
    name: qsTr("Open Database")

    ListView {
        anchors.fill: parent
        model: database.list()
        delegate: ItemDelegate {
            width: ListView.view.width
            text: modelData
            onClicked: database.open(modelData)
        }
    }
}
