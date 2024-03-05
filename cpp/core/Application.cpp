#include "Application.h"
#include <QTranslator>

Application::Application(int& argc, char* argv[]) : QGuiApplication(argc, argv) {
    setApplicationName(Name);
    setOrganizationName(Organization);
    setApplicationVersion(Version);

    installTranslators();
}

void Application::installTranslators() {
    auto memoTranslator = new QTranslator(this);
    QString language = QLocale::system().name().split("_").first();

    if (memoTranslator->load("memo-" + language, ":/i18n")) {
        installTranslator(memoTranslator);
    }
}
