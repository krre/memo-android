#pragma once
#include <QObject>
#include <QSqlDatabase>

class Database : public QObject {
    Q_OBJECT
public:
    Database(QObject* parent = nullptr);

    Q_INVOKABLE void create(const QString& name);
    Q_INVOKABLE bool isExists(const QString& name);

private:
    QString directory() const;
    QString filePath(const QString& name) const;

    QSqlDatabase m_db;
};
