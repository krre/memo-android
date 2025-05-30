#pragma once
#include <QObject>
#include <QSqlDatabase>

class Database : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(bool isOpen READ isOpen NOTIFY isOpenChanged)
public:
    struct Note {
        int id;
        int parentId;
        int pos;
        QString title;
    };

    Database(QObject* parent = nullptr);

    Q_INVOKABLE void create(const QString& name);
    Q_INVOKABLE void open(const QString& name);
    Q_INVOKABLE void close();
    Q_INVOKABLE void remove(const QString& name);
    Q_INVOKABLE void rename(const QString& oldName, const QString& newName);
    Q_INVOKABLE bool isExists(const QString& name);
    Q_INVOKABLE QStringList files() const;

    QString name() const;
    bool isOpen() const;

    int insertNote(int parentId, int pos, int depth, const QString& title) const;
    Q_INVOKABLE void insertRemoteNote(int id, int parentId, int pos, int depth, const QString& title, const QString& note) const;
    Q_INVOKABLE QVariantMap note(int id) const;
    QList<Note> notes() const;
    void removeNote(int id) const;

    Q_INVOKABLE void updateNoteValue(int id, const QString& name, const QVariant& value) const;
    Q_INVOKABLE QVariant noteValue(int id, const QString& name) const;

    QSqlQuery exec(const QString& sql, const QVariantMap& params = {}) const;
    const QSqlDatabase& db() const { return m_db; }

signals:
    void nameChanged(const QString& name);
    void isOpenChanged(bool isOpen);

private:
    void setName(const QString& name);
    QVariantMap queryToNote(const QSqlQuery& query) const;

    QString directory() const;
    QString filePath(const QString& name) const;
    QString normalizeName(const QString& name) const;

    QSqlDatabase m_db;
    QString m_name;
};
