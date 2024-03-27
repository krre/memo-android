import QtQuick
import QtQuick.Controls

Page {
    required property string name
    default property alias data: content.data
    property bool isInitialPage: false
    property var buttons: []

    function pushPage(item, properties, operation) {
        StackView.view.push(item, properties, operation)
    }

    function popPage() {
        StackView.view.pop()
    }

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: 10
    }
}
