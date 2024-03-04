#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>
#include <QTranslator>
#include "config.h"

int main(int argc, char* argv[]) {
    QGuiApplication::setApplicationName("Memo");
    QGuiApplication::setOrganizationName("Memo");
    QGuiApplication::setApplicationVersion(PROJECT_VERSION);

    QGuiApplication app(argc, argv);

    QIcon::setThemeName("memo");
    QQuickStyle::setStyle("Material");

    auto memoTranslator = new QTranslator(&app);
    QString language = QLocale::system().name().split("_").first();

    if (memoTranslator->load("memo-" + language, ":/i18n")) {
        app.installTranslator(memoTranslator);
    }

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/qml/Main.qml"));

    if (engine.rootObjects().isEmpty()) {
        return EXIT_FAILURE;
    }

    return app.exec();
}
