import QtQuick
import QtQuick.Controls

ToolButton {
    action: Action {
        id: optionsMenuAction
        icon.source: "qrc:/assets/icons/dots-vertical.svg"
        onTriggered: optionsMenu.open()
    }

    Menu {
        id: optionsMenu
        x: parent.width - width
        transformOrigin: Menu.TopRight

        Action {
            text: qsTr("About")
            onTriggered: aboutDialogComp.createObject(root)
        }
    }

    Shortcut {
        sequence: "Menu"
        onActivated: optionsMenuAction.trigger()
    }

    Component {
        id: aboutDialogComp
        AboutDialog {}
    }
}
