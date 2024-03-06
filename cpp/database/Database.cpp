#include "Database.h"
#include "Migrater.h"
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

    Migrater migrater(this);
    migrater.run();

    qInfo().noquote() << "Opened database:" << filePath(name);
}

bool Database::isExists(const QString& name) {
    return QFileInfo::exists(filePath(name));
}

QStringList Database::list() const {
    QStringList result;
    QDir dir(directory());

    for (const auto& fi : dir.entryInfoList({ "*.db" }, QDir::Files)) {
        result.append(fi.fileName());
    }

    return result;
}

QSqlQuery Database::exec(const QString& sql, const QVariantMap& params) const {
    QSqlQuery query;
    query.prepare(sql);

    for (auto it = params.cbegin(); it != params.cend(); it++) {
        query.bindValue(":" + it.key(), it.value());
    }

    if (!query.exec()) {
        qCritical().noquote() << "SQL error:" << query.lastError();
        return QSqlQuery();
    }

    return query;
}

QString Database::directory() const {
    return QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
}

QString Database::filePath(const QString& name) const {
    return directory() + "/" + name + (name.right(3) == ".db" ? "" : ".db");
}
