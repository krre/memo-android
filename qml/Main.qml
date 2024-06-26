import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Memo
import "page/database"
import "page/view"

ApplicationWindow {
    id: root
    width: 400
    height: 770
    visible: true
    title: app.name

    Component.onCompleted: {
        x = (Screen.desktopAvailableWidth - width) / 2
        y = (Screen.desktopAvailableHeight - height) / 2

        if (database.isExists(databaseSettings.name)) {
            database.open(databaseSettings.name)
            openNodeTreeView()
        } else {
            stackView.push(databasePageComp)
        }
    }

    Component.onDestruction: databaseSettings.name = database.name

    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton {
                action: navigateAction
            }

            Label {
                id: title
                Layout.fillWidth: true
                text: stackView.currentItem && stackView.currentItem.name
                elide: Text.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
            }

            Row {
                data: stackView.currentItem ? stackView.currentItem.toolBar : []
            }

            ToolButton {
                action: optionsMenuAction

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    Action {
                        text: qsTr("About")
                        onTriggered: aboutDialogComp.createObject(root)
                    }
                }
            }
        }
    }

    function openNodeTreeView() {
        stackView.clear()
        stackView.push(noteTreePageComp)
    }

    Settings {
        id: databaseSettings
        category: "Database"
        property string name
    }

    Settings {
        id: remoteSettings
        category: "Remote"
        property string ip
        property int port
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

    Action {
        id: quitAction
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit()
    }

    Drawer {
        id: drawer
        height: parent.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                width: parent.width
                visible: database.name
                text: qsTr("Close")
                onClicked: {
                    database.close()
                    stackView.clear()
                    stackView.push(databasePageComp)
                    drawer.close()
                }
            }

            ItemDelegate {
                width: parent.width
                text: qsTr("Exit")
                onClicked: quitAction.trigger()
            }
        }
    }

    Database {
        id: database
    }

    Component {
        id: aboutDialogComp
        AboutDialog {}
    }

    Component {
        id: databasePageComp
        DatabasePage {}
    }

    Component {
        id: noteTreePageComp
        NoteTreePage {}
    }

    StackView {
        id: stackView
        anchors.fill: parent
    }
}
