#pragma once
#include "config.h"
#include <QGuiApplication>

class Application : public QGuiApplication {
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString version READ version CONSTANT)
    Q_PROPERTY(QString qtVersion READ qtVersion CONSTANT)
    Q_PROPERTY(QString url READ url CONSTANT)
    Q_PROPERTY(QString years READ years CONSTANT)
    Q_PROPERTY(QString buildDate READ buildDate CONSTANT)
    Q_PROPERTY(QString buildTime READ buildTime CONSTANT)
public:
    static constexpr auto Organization = "Memo";
    static constexpr auto Name = "Memo";
    static constexpr auto Version = PROJECT_VERSION;
    static constexpr auto QtVersion = QT_VERSION_STR;
    static constexpr auto Url = "https://github.com/krre/memo-android";
    static constexpr auto Years = "2024-2025";
    static constexpr auto BuildDate = __DATE__;
    static constexpr auto BuildTime = __TIME__;

    Application(int& argc, char* argv[]);

private:
    QString name() const { return Name; }
    QString version() const { return Version; }
    QString qtVersion() const { return QtVersion; }
    QString url() const { return Url; }
    QString years() const { return Years; }
    QString buildDate() const { return BuildDate; }
    QString buildTime() const { return BuildTime; }

    void installTranslators();
};
