import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import ".."

NamedPage {
    name: qsTr("Connect to Database")

    function sendRequest(endpoint, callback) {
        const request = new XMLHttpRequest();

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (!request.response) {
                    busyIndicator.running = false
                    messageDialog.open()
                    return
                }

                const response = {
                    status : request.status,
                    headers : request.getAllResponseHeaders(),
                    contentType : request.responseType,
                    content : request.response
                }

                callback(response)
            }
        }

        const url = "http://" + ip.text + ":" + port.text + "/" + endpoint
        request.open("GET", url)
        request.setRequestHeader("token", token.text)
        request.send()
    }

    MessageDialog {
        id: messageDialog
        buttons: MessageDialog.Ok
        text: qsTr("Network error")
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width
        spacing: 10

        TextField {
            id: ip
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("IP address")
            text: remoteSettings.ip
            focus: true
        }

        TextField {
            id: port
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("Port")
            text: remoteSettings.port
        }

        TextField {
            id: token
            Layout.preferredWidth: parent.width
            placeholderText: qsTr("Token")
        }

        Button {
            Layout.alignment: Qt.AlignRight
            text: qsTr("OK")
            enabled: ip.text && port.text && token.text && !busyIndicator.running
            onClicked: {
                busyIndicator.running = true

                sendRequest("name", function(response) {
                    database.close()
                    database.create(JSON.parse(response.content).name)

                    remoteSettings.ip = ip.text
                    remoteSettings.port = +port.text

                    sendRequest("notes", function(response) {
                        const notes = JSON.parse(response.content)

                        for (const note of notes) {
                            database.insertRemoteNote(note.id, note.parentId, note.pos, note.depth, note.title, note.note)
                        }

                        busyIndicator.running = false

                        openNodeTreeView()
                    })
                })
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: running
        running: false
    }
}
