#pragma once
#include <QObject>
#include <QVariant>

class TreeItem : public QObject {
    Q_OBJECT
public:
    explicit TreeItem(TreeItem* parent = nullptr);
    ~TreeItem();

    TreeItem* parent();
    void setParent(TreeItem* parent);

    TreeItem* find(int id);

    TreeItem* child(int number) const;
    Q_INVOKABLE int childCount() const;
    int childNumber() const;

    QVariant data() const;
    void setData(const QVariant& data);

    bool insertChild(int position, TreeItem* item = nullptr);
    bool removeChild(int position);

    int id() const;
    void setId(int id);

    int depth();

private:
    QList<TreeItem*> m_children;
    QVariant m_data;
    TreeItem* m_parent = nullptr;
    int m_id = 0;
};
