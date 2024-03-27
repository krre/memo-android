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
    Q_INVOKABLE bool isExists(const QString& name);
    Q_INVOKABLE QStringList list() const;

    QString name() const;

    QSqlQuery exec(const QString& sql, const QVariantMap& params = QVariantMap()) const;
    const QSqlDatabase& db() const { return m_db; }

signals:
    void nameChanged(const QString& name);

private:
    void setName(const QString& name);

    QString directory() const;
    QString filePath(const QString& name) const;
    QString normalizeName(const QString& name) const;

    QSqlDatabase m_db;
    QString m_name;
};
