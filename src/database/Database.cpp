#include "Database.h"
#include "Migrater.h"
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

Database::Database(QObject* parent) : QObject(parent) {
    m_db = QSqlDatabase::addDatabase("QSQLITE");
}

void Database::create(const QString& name) {
    close();

    QDir().mkpath(directory());
    QFile::remove(filePath(name));
    open(name);
}

void Database::open(const QString& name) {
    if (name == m_name) return;
    close();

    m_db.setDatabaseName(filePath(name));

    if (!m_db.open()) {
        qCritical().noquote() << "Error opening database:" << m_db.lastError();
        return;
    }

    Migrater migrater(this);
    migrater.run();

    emit isOpenChanged(true);
    setName(normalizeName(name));

    qInfo().noquote() << "Database opened:" << filePath(name);
}

void Database::close() {
    if (!isOpen()) return;

    m_db.close();
    QString name = m_name;
    setName("");
    emit isOpenChanged(false);
    qInfo().noquote() << "Database closed:" << filePath(name);
}

void Database::remove(const QString& name) {
    if (name == m_name) close();
    QFile::remove(filePath(name));
    qInfo().noquote() << "Database removed:" << filePath(name);
}

void Database::rename(const QString& oldName, const QString& newName) {
    if (oldName == m_name) close();
    QFile::rename(filePath(oldName), filePath(newName));
    qInfo().noquote() << "Database renamed:" << filePath(newName);
}

bool Database::isExists(const QString& name) {
    return QFileInfo::exists(filePath(name));
}

QStringList Database::list() const {
    QStringList result;
    const auto fileInfos = QDir(directory()).entryInfoList({ "*.db" }, QDir::Files);

    for (const auto& fi : fileInfos) {
        QString name = fi.fileName().left(fi.fileName().size() - 3); // Name without extension .db
        result.append(name);
    }

    return result;
}

QString Database::name() const {
    return m_name;
}

bool Database::isOpen() const {
    return m_db.isOpen();
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

void Database::insertRemoteNote(int id, int parentId, int pos, int depth, const QString& title, const QString& note) const {
    QVariantMap params = {
        { "id", id },
        { "parent_id", parentId },
        { "pos", pos },
        { "depth", depth },
        { "title", title },
        { "note", note }
    };

    exec("INSERT INTO notes (id, parent_id, pos, depth, title, note) VALUES (:id, :parent_id, :pos, :depth, :title, :note)", params);
}

QVariantMap Database::note(int id) const {
    QSqlQuery query = exec("SELECT * FROM notes WHERE id = :id", { { "id", id } });
    query.next();
    return queryToNote(query);
}

QList<Database::Note> Database::notes() const {
    QSqlQuery query = exec("SELECT id, parent_id, pos, title FROM notes ORDER BY depth, pos");
    QList<Database::Note> result;

    while (query.next()) {
        Note note;
        note.id = query.value("id").toInt();
        note.parentId = query.value("parent_id").toInt();
        note.pos = query.value("pos").toInt();
        note.title = query.value("title").toString();

        result.append(note);
    }

    return result;
}

void Database::removeNote(int id) const {
    exec("DELETE FROM notes WHERE id = :id", { { "id", id } });
}

void Database::updateNoteValue(int id, const QString& name, const QVariant& value) const {
    QVariantMap params = {
        { "id", id },
        { "value", value },
    };

    QString updateDate = name == "note" ? ", updated_at = datetime('now', 'localtime')" : "";
    exec(QString("UPDATE notes SET %1 = :value %2 WHERE id = :id").arg(name, updateDate), params);
}

QVariant Database::noteValue(int id, const QString& name) const {
    QSqlQuery query = exec(QString("SELECT %1 FROM notes WHERE id = :id").arg(name), { { "id", id } });
    return query.first() ? query.value(name) : QVariant();
}

QSqlQuery Database::exec(const QString& sql, const QVariantMap& params) const {
    QSqlQuery query;
    query.prepare(sql);

    for (auto it = params.cbegin(); it != params.cend(); ++it) {
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

    for (int i = 0; i < query.record().count(); ++i) {
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
