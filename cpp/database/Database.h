#pragma once
#include <QObject>
#include <QSqlDatabase>
#include <QVariantMap>

class Database : public QObject {
    Q_OBJECT
public:
    Database(QObject* parent = nullptr);

    Q_INVOKABLE void create(const QString& name);
    Q_INVOKABLE void open(const QString& name);
    Q_INVOKABLE bool isExists(const QString& name);

    QSqlQuery exec(const QString& sql, const QVariantMap& params = QVariantMap()) const;
    const QSqlDatabase& db() const { return m_db; }

private:
    QString directory() const;
    QString filePath(const QString& name) const;

    QSqlDatabase m_db;
};
