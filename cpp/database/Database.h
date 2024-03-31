#pragma once
#include <QObject>
#include <QSqlDatabase>
#include <QVariantMap>

class Database : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
public:
    Database(QObject* parent = nullptr);

    Q_INVOKABLE void create(const QString& name);
    Q_INVOKABLE void open(const QString& name);
    Q_INVOKABLE void close();
    Q_INVOKABLE bool isExists(const QString& name);
    Q_INVOKABLE QStringList list() const;

    QString name() const;

    Q_INVOKABLE int insertNote(int parentId, int pos, int depth, const QString& title) const;
    Q_INVOKABLE QVariantList notes() const;
    Q_INVOKABLE void removeNote(int id) const;

    Q_INVOKABLE void updateNoteValue(int id, const QString& name, const QVariant& value) const;

    QSqlQuery exec(const QString& sql, const QVariantMap& params = QVariantMap()) const;
    const QSqlDatabase& db() const { return m_db; }

signals:
    void nameChanged(const QString& name);

private:
    void setName(const QString& name);
    QVariantMap queryToNote(const QSqlQuery& query) const;

    QString directory() const;
    QString filePath(const QString& name) const;
    QString normalizeName(const QString& name) const;

    QSqlDatabase m_db;
    QString m_name;
};
