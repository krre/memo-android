import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "page/database"

ApplicationWindow {
    width: 400
    height: 770
    visible: true
    title: "Memo"

    Component.onCompleted: {
        x = (Screen.desktopAvailableWidth - width) /2
        y = (Screen.desktopAvailableHeight - height) /2
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton {
                action: navigateAction
            }

            Label {
                id: title
                text: stackView.currentItem.name
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                action: optionsMenuAction

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    Action {
                        text: qsTr("About")
                    }
                }
            }
        }
    }

    Shortcut {
        sequences: ["Esc", "Back"]
        enabled: stackView.depth > 1
        onActivated: navigateAction.trigger()
    }

    Action {
        id: navigateAction
        icon.name: stackView.depth > 1 ? "back" : "drawer"
        onTriggered: {
            if (stackView.depth > 1) {
                stackView.pop()
            } else {
                drawer.open()
            }
        }
    }

    Shortcut {
        sequence: "Menu"
        onActivated: optionsMenuAction.trigger()
    }

    Action {
        id: optionsMenuAction
        icon.name: "menu"
        onTriggered: optionsMenu.open()
    }

    Drawer {
        id: drawer
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: DatabasePage {}
    }
}
