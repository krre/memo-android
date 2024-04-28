import QtQuick
import QtQuick.Controls

Dialog {
    id: root
    anchors.centerIn: parent
    modal: true
    focus: true
    title: qsTr("About")
    standardButtons: Dialog.Ok

    Component.onCompleted: open()

    onVisibleChanged: if (!visible) root.destroy()

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
