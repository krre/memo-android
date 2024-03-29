#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include "core/Application.h"
#include "database/Database.h"
#include "treeview/TreeModel.h"
#include "treeview/TreeItem.h"

int main(int argc, char* argv[]) {
    Application app(argc, argv);

    QIcon::setThemeName("memo");
    QQuickStyle::setStyle("Material");

    qmlRegisterType<Database>("Memo", 1, 0, "Database");
    qmlRegisterType<TreeModel>("Memo", 1, 0, "TreeModel");
    qmlRegisterUncreatableType<TreeItem>("Memo", 1, 0, "TreeItem", "Uncreatable type");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("app", &app);
    engine.load(QUrl("qrc:/qml/Main.qml"));

    if (engine.rootObjects().isEmpty()) {
        return EXIT_FAILURE;
    }

    return app.exec();
}
