import QtQuick
import QtQuick.Controls

Page {
    required property string name

    function pushPage(item, properties, operation) {
        StackView.view.push(item, properties, operation)
    }

    function popPage() {
        StackView.view.pop()
    }
}
