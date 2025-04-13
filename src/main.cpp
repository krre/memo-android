#include "core/Application.h"
#include "database/Database.h"
#include "treeview/TreeModel.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

int main(int argc, char* argv[]) {
    Application app(argc, argv);

    QQuickStyle::setStyle("Material");

    qmlRegisterType<Database>(PROJECT_TITLE, 1, 0, "Database");
    qmlRegisterType<TreeModel>(PROJECT_TITLE, 1, 0, "TreeModel");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("app", &app);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, [] {
        QCoreApplication::exit(EXIT_FAILURE);
    }, Qt::QueuedConnection);

    engine.load(QUrl("qrc:/qml/Main.qml"));

    return app.exec();
}
