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
    if (name == m_name) return;

    m_db.close();
    m_db.setDatabaseName(filePath(name));

    if (!m_db.open()) {
        qCritical().noquote() << "Error opening database:" << m_db.lastError();
        return;
    }

    Migrater migrater(this);
    migrater.run();

    setName(normalizeName(name));

    qInfo().noquote() << "Database opened:" << filePath(name);
}

void Database::close() {
    m_db.close();
    QString name = m_name;
    setName("");
    qInfo().noquote() << "Database closed:" << filePath(name);
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

QString Database::name() const {
    return m_name;
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

void Database::setName(const QString& name) {
    if (name == m_name) return;
    m_name = name;
    emit nameChanged(name);
}

QString Database::directory() const {
    return QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
}

QString Database::filePath(const QString& name) const {
    return directory() + "/" + normalizeName(name) + ".db";
}

QString Database::normalizeName(const QString& name) const {
    return name.right(3) == ".db" ? name.left(name.size() - 3) : name;
}
