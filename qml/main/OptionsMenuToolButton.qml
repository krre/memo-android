import QtQuick
import QtQuick.Controls

ToolButton {
    action: Action {
        id: optionsMenuAction
        icon.source: "qrc:/assets/icons/dots-vertical.svg"
        onTriggered: optionsMenu.open()
    }

    OptionsMenu {
        id: optionsMenu
        x: parent.width - width
    }

    Shortcut {
        sequence: "Menu"
        onActivated: optionsMenuAction.trigger()
    }
}
