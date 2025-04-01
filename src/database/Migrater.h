#pragma once
#include <QHash>

class Database;

class Migrater {
public:
    Migrater(Database* db);
    void run();

private:
    int version() const;
    void setVersion(int version) const;

    void migration1() const; // 06.03.2024

    Database* m_db = nullptr;
    QHash<int, std::function<void()>> migrations;
};
