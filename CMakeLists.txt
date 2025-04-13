cmake_minimum_required(VERSION 4.0)

project(memo VERSION 1.0.0)

set(PROJECT_TITLE Memo)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(REQUIRED_QT_VERSION 6.9)

find_package(Qt6 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS Quick QuickControls2 Sql LinguistTools)

qt_standard_project_setup(
    REQUIRES ${REQUIRED_QT_VERSION}
    I18N_TRANSLATED_LANGUAGES ru
)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

configure_file(src/config.h.in config.h @ONLY)

qt_add_executable(${PROJECT_NAME}
    src/main.cpp
)

qt_add_qml_module(${PROJECT_NAME}
    URI ${PROJECT_NAME}
    NO_RESOURCE_TARGET_PATH

    QML_FILES
        qml/Main.qml
        qml/main/OptionsMenu.qml
        qml/main/MenuToolButton.qml
        qml/main/AboutDialog.qml
        qml/pages/database/CreatePage.qml
        qml/pages/database/OpenPage.qml
        qml/pages/database/ConnectPage.qml
        qml/pages/NamePage.qml
        qml/pages/database/DatabasePage.qml
        qml/pages/treeview/NoteTreePage.qml
        qml/pages/treeview/NotePage.qml
        qml/pages/treeview/NameDialog.qml

    RESOURCES
        assets/icons/square-plus.svg
        assets/icons/arrow-left.svg
        assets/icons/menu.svg
        assets/icons/dots-vertical.svg
        assets/icons/deselect.svg
        assets/icons/edit.svg
        assets/icons/device-floppy.svg
        assets/icons/cancel.svg
        qtquickcontrols2.conf

    SOURCES
        src/core/Application.h src/core/Application.cpp
        src/database/Database.h src/database/Database.cpp
        src/database/Migrater.h src/database/Migrater.cpp
        src/treeview/TreeItem.cpp src/treeview/TreeItem.h
        src/treeview/TreeModel.cpp src/treeview/TreeModel.h
)

qt_add_translations(${PROJECT_NAME}
    SOURCE_TARGETS ${PROJECT_NAME}
    NO_GENERATE_PLURALS_TS_FILE
    TS_OUTPUT_DIRECTORY i18n
    # LUPDATE_OPTIONS -no-obsolete
)

# For visibility in IDE (e.g., Qt Creator)
add_custom_target(other
    SOURCES
    README.md
    src/config.h.in
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME ${PROJECT_TITLE}
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

target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)

include(GNUInstallDirs)

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
