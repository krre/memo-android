#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>

int main(int argc, char* argv[]) {
    QGuiApplication::setApplicationName("Memo");
    QGuiApplication::setOrganizationName("Memo");

    QGuiApplication app(argc, argv);

    QIcon::setThemeName("memo-qml");
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/qml/Main.qml"));

    if (engine.rootObjects().isEmpty()) {
        return EXIT_FAILURE;
    }

    return app.exec();
}
