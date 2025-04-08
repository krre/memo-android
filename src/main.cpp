#include "core/Application.h"
#include "database/Database.h"
#include "treeview/TreeModel.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>

int main(int argc, char* argv[]) {
    Application app(argc, argv);

    QIcon::setThemeSearchPaths({ ":/assets/icons" });
    // QIcon::setThemeName("memo");

    QQuickStyle::setStyle("Material");

    qmlRegisterType<Database>("Memo", 1, 0, "Database");
    qmlRegisterType<TreeModel>("Memo", 1, 0, "TreeModel");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("app", &app);
    engine.load(QUrl("qrc:/qml/Main.qml"));

    if (engine.rootObjects().isEmpty()) {
        return EXIT_FAILURE;
    }

    return app.exec();
}
