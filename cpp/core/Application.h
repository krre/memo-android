#pragma once
#include "config.h"
#include <QGuiApplication>

class Application : public QGuiApplication {
public:
    static constexpr auto Organization = "Memo";
    static constexpr auto Name = "Memo";
    static constexpr auto Version = PROJECT_VERSION;
    static constexpr auto Url = "https://github.com/krre/memo-android";
    static constexpr auto Copyright = "Copyright © 2024, Vladimir Zarypov";
    static constexpr auto BuildDate = __DATE__;
    static constexpr auto BuildTime = __TIME__;

    Application(int& argc, char* argv[]);

private:
    void installTranslators();
};
