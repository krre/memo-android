import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "page/database"

ApplicationWindow {
    width: 400
    height: 770
    visible: true
    title: app.name

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
                        onTriggered: aboutDialog.open()
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
        height: parent.height

        ListView {
            id: listView
            focus: true
            currentIndex: -1
            anchors.fill: parent

            model: ListModel {
                ListElement { title: qsTr("Exit") }
            }

            delegate: ItemDelegate {
                id: delegateItem
                width: ListView.view.width
                text: title

                onClicked: {
                    if (index == 0) {
                        Qt.quit()
                    }

                    drawer.close()
                }
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

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: DatabasePage {}
    }
}
