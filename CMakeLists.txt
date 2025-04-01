cmake_minimum_required(VERSION 4.0)

project(memo VERSION 1.0.0)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(REQUIRED_QT_VERSION 6.8)

find_package(Qt6 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS Quick QuickControls2 Sql LinguistTools)

qt_standard_project_setup(REQUIRES ${REQUIRED_QT_VERSION})

include_directories(${CMAKE_CURRENT_BINARY_DIR})

configure_file(cpp/config.h.in config.h @ONLY)

qt_add_executable(${PROJECT_NAME}
    cpp/main.cpp
)

qt_add_qml_module(${PROJECT_NAME}
    URI memo.android
    NO_RESOURCE_TARGET_PATH

    QML_FILES
        qml/Main.qml
        qml/AboutDialog.qml
        qml/pages/database/CreatePage.qml
        qml/pages/database/OpenPage.qml
        qml/pages/database/ConnectPage.qml
        qml/pages/NamePage.qml
        qml/pages/database/DatabasePage.qml
        qml/pages/treeview/NoteTreePage.qml
        qml/pages/treeview/NotePage.qml
        qml/pages/treeview/NameDialog.qml

    RESOURCES
        icons/memo/20x20/add_box.png
        icons/memo/20x20/back.png
        icons/memo/20x20/cancel.png
        icons/memo/20x20/deselect.png
        icons/memo/20x20/drawer.png
        icons/memo/20x20/edit.png
        icons/memo/20x20/menu.png
        icons/memo/20x20/save.png
        icons/memo/20x20@2/add_box.png
        icons/memo/20x20@2/back.png
        icons/memo/20x20@2/cancel.png
        icons/memo/20x20@2/deselect.png
        icons/memo/20x20@2/drawer.png
        icons/memo/20x20@2/edit.png
        icons/memo/20x20@2/menu.png
        icons/memo/20x20@2/save.png
        icons/memo/20x20@3/add_box.png
        icons/memo/20x20@3/back.png
        icons/memo/20x20@3/cancel.png
        icons/memo/20x20@3/deselect.png
        icons/memo/20x20@3/drawer.png
        icons/memo/20x20@3/edit.png
        icons/memo/20x20@3/menu.png
        icons/memo/20x20@3/save.png
        icons/memo/20x20@4/add_box.png
        icons/memo/20x20@4/back.png
        icons/memo/20x20@4/cancel.png
        icons/memo/20x20@4/deselect.png
        icons/memo/20x20@4/drawer.png
        icons/memo/20x20@4/edit.png
        icons/memo/20x20@4/menu.png
        icons/memo/20x20@4/save.png
        icons/memo/index.theme
        qtquickcontrols2.conf

    SOURCES
        cpp/core/Application.h cpp/core/Application.cpp
        cpp/database/Database.h cpp/database/Database.cpp
        cpp/database/Migrater.h cpp/database/Migrater.cpp
        cpp/treeview/TreeItem.cpp cpp/treeview/TreeItem.h
        cpp/treeview/TreeModel.cpp cpp/treeview/TreeModel.h
)

SET(TS_SOURCE i18n/${PROJECT_NAME}-ru.ts)

qt_add_translations(${PROJECT_NAME}
    TS_FILES ${TS_SOURCE}
    SOURCE_TARGETS ${PROJECT_NAME}
    # LUPDATE_OPTIONS -no-obsolete
)

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
set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME "Memo"
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmemo
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Sql
)

include(GNUInstallDirs)

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
