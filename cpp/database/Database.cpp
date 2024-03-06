#include "Database.h"
#include <QStandardPaths>
#include <QtSql>
#include <QDebug>

Database::Database(QObject* parent) : QObject(parent) {
    m_db = QSqlDatabase::addDatabase("QSQLITE");
}

void Database::create(const QString& name) {
    QString filePath = directory() + "/" + name + ".db";
    qInfo().noquote() << "Created database:" << filePath;
}

bool Database::isExists(const QString& name) {
    return QFileInfo::exists(filePath(name));
}

QString Database::directory() const {
    return QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/databases/memo";
}

QString Database::filePath(const QString& name) const {
    return directory() + "/" + name + ".db";
}
