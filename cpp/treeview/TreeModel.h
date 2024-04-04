#pragma once
#include <QAbstractItemModel>

class TreeItem;
class Database;

class TreeModel : public QAbstractItemModel {
    Q_OBJECT
    Q_PROPERTY(Database* database READ database WRITE setDatabase NOTIFY databaseChanged FINAL)
public:
    TreeModel(QObject* parent = nullptr);
    ~TreeModel() override;

    QModelIndex index(int row, int column, const QModelIndex& parent) const override;
    QModelIndex parent(const QModelIndex& child) const override;
    int rowCount(const QModelIndex& parent) const override;
    int columnCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role = Qt::EditRole) override;

    Qt::DropActions supportedDropActions() const override;
    Qt::DropActions supportedDragActions() const override;
    QStringList mimeTypes() const override;
    QMimeData* mimeData(const QModelIndexList& indexes) const override;
    bool canDropMimeData(const QMimeData* mimeData, Qt::DropAction action, int row, int column, const QModelIndex& parent) const override;
    bool dropMimeData(const QMimeData* mimeData, Qt::DropAction action, int row, int column, const QModelIndex& parent) override;

    bool insertRows(int position, int rows, const QModelIndex& parent = QModelIndex()) override;
    bool removeRows(int position, int rows, const QModelIndex& parent = QModelIndex()) override;
    bool moveRows(const QModelIndex& sourceParent, int sourceRow, int count, const QModelIndex& destinationParent, int destinationChild) override;

    Q_INVOKABLE void insertNotes();
    Q_INVOKABLE QModelIndex insertNote(const QModelIndex& parent, const QString& title);
    Q_INVOKABLE void renameNote(const QModelIndex& index, const QString& title);
    Q_INVOKABLE void removeNote(const QModelIndex& index);
    Q_INVOKABLE QVariantMap note(const QModelIndex& index);

    Database* database() const;
    void setDatabase(Database* database);

signals:
    void itemDropped(const QModelIndex& index);
    void databaseChanged();

private:
    QList<int> childIds(TreeItem* item) const;
    QModelIndex itemIndex(TreeItem* item) const;
    TreeItem* item(const QModelIndex& index) const;

    QScopedPointer<TreeItem> m_rootItem;
    Database* m_database = nullptr;
};
