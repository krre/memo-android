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

int Database::insertNote(int parentId, int pos, int depth, const QString& title) const {
    QVariantMap params = {
        { "parent_id", parentId },
        { "pos", pos },
        { "depth", depth },
        { "title", title }
    };

    QSqlQuery query = exec("INSERT INTO notes (parent_id, pos, depth, title) VALUES (:parent_id, :pos, :depth, :title)", params);
    return query.lastInsertId().toLongLong();
}

QVariantList Database::notes() const {
    QSqlQuery query = exec("SELECT * FROM notes ORDER BY depth, pos");
    QVariantList result;

    while (query.next()) {
        result.append(queryToNote(query));
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

void Database::setName(const QString& name) {
    if (name == m_name) return;
    m_name = name;
    emit nameChanged(name);
}

QVariantMap Database::queryToNote(const QSqlQuery& query) const {
    QVariantMap result;

    for (int i = 0; i < query.record().count(); i++) {
        result[query.record().fieldName(i)] = query.record().value(i);
    }

    return result;
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
