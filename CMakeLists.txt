cmake_minimum_required(VERSION 3.22)

project(memo VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.6 REQUIRED COMPONENTS Quick QuickControls2 Sql LinguistTools)

qt_standard_project_setup(REQUIRES 6.6)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

configure_file(cpp/config.h.in config.h @ONLY)

qt_add_executable(memo
    cpp/main.cpp
)

qt_add_qml_module(memo
    URI memoqml
    NO_RESOURCE_TARGET_PATH
    QML_FILES qml/Main.qml
        qml/page/database/CreatePage.qml
        qml/page/database/OpenPage.qml
        qml/page/database/ConnectPage.qml
        qml/page/NamePage.qml
        qml/page/database/DatabasePage.qml
        qml/page/view/NoteTreePage.qml
    RESOURCES icons/memo/20x20/back.png
        icons/memo/20x20/drawer.png
        icons/memo/20x20/menu.png
        icons/memo/20x20@2/back.png
        icons/memo/20x20@2/drawer.png
        icons/memo/20x20@2/menu.png
        icons/memo/20x20@3/back.png
        icons/memo/20x20@3/drawer.png
        icons/memo/20x20@3/menu.png
        icons/memo/20x20@4/back.png
        icons/memo/20x20@4/drawer.png
        icons/memo/20x20@4/menu.png
        icons/memo/index.theme
        qmldir
        qtquickcontrols2.conf
    SOURCES cpp/core/Application.h cpp/core/Application.cpp
        cpp/database/Database.h cpp/database/Database.cpp
        cpp/database/Migrater.h cpp/database/Migrater.cpp
        SOURCES cpp/treeview/TreeItem.cpp cpp/treeview/TreeItem.h cpp/treeview/TreeModel.cpp cpp/treeview/TreeModel.h
)

SET(TS_SOURCE i18n/memo-ru.ts)

qt_add_translations(memo TS_FILES ${TS_SOURCE})

# For visibility in IDE (e.g., Qt Creator)
add_custom_target(other
    SOURCES
    README.md
    cpp/config.h.in
    ${TS_SOURCE}
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(memo PROPERTIES
    OUTPUT_NAME "Memo"
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmemo
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)

target_link_libraries(memo PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Sql
)

include(GNUInstallDirs)

install(TARGETS memo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
