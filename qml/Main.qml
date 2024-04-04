import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Memo 1.0
import "page/database"
import "page/view"

ApplicationWindow {
    width: 400
    height: 770
    visible: true
    title: app.name

    Component.onCompleted: {
        x = (Screen.desktopAvailableWidth - width) /2
        y = (Screen.desktopAvailableHeight - height) /2

        if (databaseSettings.name) {
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
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
            }

            Row {
                data: stackView.currentItem ? stackView.currentItem.buttons : []
            }

            ToolButton {
                action: optionsMenuAction

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    Action {
                        text: qsTr("About")
                        onTriggered: aboutDialog.open()
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
                text: qsTr("Database")
                visible: stackView.currentItem && !stackView.currentItem.isInitialPage
                onClicked: {
                    stackView.push(databasePageComp)
                    drawer.close()
                }
            }

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

    Dialog {
        id: aboutDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        title: qsTr("About")

        Label {
            text: qsTr("<h3>%1 %2</h3><br> \
                        Note-taking for quick notes<br><br> \
                        Based on Qt %3<br> \
                        Build on %4 %5<br><br> \
                        <a href='%6'>%6</a><br><br>Copyright © %7, Vladimir Zarypov")
            .arg(app.name).arg(app.version).arg(app.qtVersion)
            .arg(app.buildDate).arg(app.buildTime)
            .arg(app.url).arg(app.copyrightYears)

            onLinkActivated: (link) => Qt.openUrlExternally(link)
        }
    }

    Database {
        id: database
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
