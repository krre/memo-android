import QtQuick
import QtQuick.Controls

Menu {
    transformOrigin: Menu.TopRight

    Action {
        text: qsTr("About")
        onTriggered: aboutDialogComp.createObject(root)
    }

    Component {
        id: aboutDialogComp
        AboutDialog {}
    }
}
