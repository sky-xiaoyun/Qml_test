#ifndef LOGMODEL_H
#define LOGMODEL_H

#include <QAbstractListModel>
#include <QSet>
#include <QVector>

struct LogEntry {
    QString timestamp;
    QString level;      // DEBUG/INFO/WARN/ERROR
    QString message;
    QString rawLine;
    int repeatCount = 1;    // 连续相同行合并后的重复次数
};

class LogModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(int matchCount READ matchCount NOTIFY matchCountChanged)
    Q_PROPERTY(int selectionCount READ selectionCount NOTIFY selectionChanged)

public:
    enum Roles {
        TimestampRole = Qt::UserRole + 1,
        LevelRole,
        MessageRole,
        RawLineRole,
        RepeatRole,
        SelectedRole
    };

    explicit LogModel(QObject *parent = nullptr) : QAbstractListModel(parent) {}

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    // Q_PROPERTY READ 指定的 getter：QML 里 logModel.count 靠它
    int count() const { return m_filteredEntries.count(); }

    // 搜索匹配：命中行数 / 第 index 个命中行的行号（-1 越界）
    int matchCount() const { return m_matchRows.count(); }
    Q_INVOKABLE int matchRowAt(int index) const;

    // 选择：单选（单击）
    int selectionCount() const { return m_selectedRows.count(); }
    Q_INVOKABLE void selectRow(int row);

    Q_INVOKABLE void loadFile(const QString &path);
    Q_INVOKABLE void filterByLevel(const QString &level);
    Q_INVOKABLE void search(const QString &keyword);
    Q_INVOKABLE void clear();

signals:
    void countChanged();                   // Q_PROPERTY NOTIFY 指定的信号（必须有）
    void matchCountChanged();
    void selectionChanged();

private:
    QVector<LogEntry> m_allEntries;      // 原始数据
    QVector<LogEntry> m_filteredEntries; // 当前显示的数据（按级别过滤后）
    QVector<int> m_matchRows;            // 当前可见行中命中关键词的行号
    QSet<int> m_selectedRows;            // 当前选中的行号（过滤后的行号）
    QString m_currentLevel = "ALL";
    QString m_currentKeyword;
    void applyFilter();
    void updateMatches();
    void notifySelectionChanged();
};

#endif // LOGMODEL_H
