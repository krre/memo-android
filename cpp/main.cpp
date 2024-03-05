#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>
#include "core/Application.h"

int main(int argc, char* argv[]) {
    Application app(argc, argv);

    QIcon::setThemeName("memo");
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/qml/Main.qml"));

    if (engine.rootObjects().isEmpty()) {
        return EXIT_FAILURE;
    }

    return app.exec();
}
