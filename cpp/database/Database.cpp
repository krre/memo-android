#include "Database.h"
#include <QStandardPaths>
#include <QtSql>
#include <QDebug>

Database::Database(QObject* parent) : QObject(parent) {
    m_db = QSqlDatabase::addDatabase("QSQLITE");
}

void Database::create(const QString& name) {
    QDir().mkpath(directory());
    QFile::remove(filePath(name));
    open(name);
}

void Database::open(const QString& name) {
    m_db.close();
    m_db.setDatabaseName(filePath(name));

    if (!m_db.open()) {
        qCritical().noquote() << "Error opening database:" << m_db.lastError();
        return;
    }

    qInfo().noquote() << "Opened database:" << filePath(name);
}

bool Database::isExists(const QString& name) {
    return QFileInfo::exists(filePath(name));
}

QString Database::directory() const {
    return QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
}

QString Database::filePath(const QString& name) const {
    return directory() + "/" + name + ".db";
}
