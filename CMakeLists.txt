cmake_minimum_required(VERSION 3.16)

project(Memo VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(Memo
    cpp/main.cpp
)

qt_add_qml_module(Memo
    URI memo
    NO_RESOURCE_TARGET_PATH
    QML_FILES
        "qml/Main.qml"
        "qml/page/database/CreatePage.qml"
        "qml/page/database/OpenPage.qml"
        "qml/page/database/ConnectPage.qml"
        "qml/page/NamePage.qml"
        "qml/page/database/DatabasePage.qml"
    RESOURCES
        "icons/memo/20x20/back.png"
        "icons/memo/20x20/drawer.png"
        "icons/memo/20x20/menu.png"
        "icons/memo/20x20@2/back.png"
        "icons/memo/20x20@2/drawer.png"
        "icons/memo/20x20@2/menu.png"
        "icons/memo/20x20@3/back.png"
        "icons/memo/20x20@3/drawer.png"
        "icons/memo/20x20@3/menu.png"
        "icons/memo/20x20@4/back.png"
        "icons/memo/20x20@4/drawer.png"
        "icons/memo/20x20@4/menu.png"
        "icons/memo/index.theme"
        "qmldir"
        "qtquickcontrols2.conf"
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(Memo PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmemo
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)

target_link_libraries(Memo PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
)

include(GNUInstallDirs)

install(TARGETS Memo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
