#include "Application.h"
#include <QTranslator>

Application::Application(int& argc, char* argv[]) : QGuiApplication(argc, argv) {
    setApplicationName(Name);
    setOrganizationName(Organization);
    setApplicationVersion(Version);

    installTranslators();
}

void Application::installTranslators() {
    QString language = QLocale::system().name().split("_").first();
    auto appTranslator = new QTranslator(this);

    if (appTranslator->load(QString("%1_%2").arg(PROJECT_NAME, language), ":/i18n")) {
        installTranslator(appTranslator);
    }
}
