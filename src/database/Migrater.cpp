#include "Migrater.h"
#include "Database.h"
#include <QSqlQuery>

constexpr auto CurrentVersion = 1;

Migrater::Migrater(Database* db) : m_db(db) {
    migrations[1] = [this] { migration1(); };
}

void Migrater::run() {
    int dbVersion = version();

    if (dbVersion == CurrentVersion) return;

    for (int i = dbVersion + 1; i <= CurrentVersion; ++i) {
        qInfo() << "Run database migration" << i;
        migrations[i]();
    }

    setVersion(CurrentVersion);
}

int Migrater::version() const {
    if (!m_db->db().tables().contains("meta")) {
        return 0;
    }

    QSqlQuery query = m_db->exec("SELECT version FROM meta");
    return query.first() ? query.value("version").toInt() : 0;
}

void Migrater::setVersion(int version) const {
    m_db->exec("UPDATE meta SET version = :version", { { "version", version } });
}

void Migrater::migration1() const {
    m_db->exec(R"(
        CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            parent_id INTEGER,
            remote_id INTEGER,
            pos INTEGER,
            depth INTEGER,
            title TEXT,
            note TEXT,
            line INTEGER,
            created_at TIMESTAMP DEFAULT (datetime('now', 'localtime')),
            updated_at TIMESTAMP DEFAULT (datetime('now', 'localtime'))
        );)"
    );

    m_db->exec(R"(
        CREATE TABLE meta(
            version INTEGER,
            selected_id INTEGER,
            remote_database TEXT
        );)"
    );

    m_db->exec("INSERT INTO meta (version, selected_id, remote_database) VALUES (0, 0, '{}');");
}
