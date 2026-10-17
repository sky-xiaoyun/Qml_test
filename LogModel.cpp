#include "LogModel.h"

#include <QDebug>
#include <QFile>
#include <QRegularExpression>
#include <QTextStream>
#include <QUrl>

int LogModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_filteredEntries.count();
}

QVariant LogModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_filteredEntries.count())
        return QVariant();

    const LogEntry &entry = m_filteredEntries.at(index.row());
    switch (role) {
    case TimestampRole:
        return entry.timestamp;
    case LevelRole:
        return entry.level;
    case MessageRole:
        return entry.message;
    case RawLineRole:
        return entry.rawLine;
    case RepeatRole:
        return entry.repeatCount;
    case SelectedRole:
        return m_selectedRows.contains(index.row());
    }
    return QVariant();
}

QHash<int, QByteArray> LogModel::roleNames() const
{
    return {
        { TimestampRole, "timestamp" },
        { LevelRole,     "level" },
        { MessageRole,   "message" },
        { RawLineRole,   "rawLine" },
        { RepeatRole,    "repeat" },
        { SelectedRole,  "selected" }
    };
}

int LogModel::matchRowAt(int index) const
{
    if (index < 0 || index >= m_matchRows.count())
        return -1;
    return m_matchRows.at(index);
}

// ==================== 选择（单选） ====================

void LogModel::notifySelectionChanged()
{
    // 全量 dataChanged：ListView 只会刷新已实例化的 delegate（可见行），成本可接受
    if (!m_filteredEntries.isEmpty())
        emit dataChanged(index(0), index(m_filteredEntries.count() - 1), {SelectedRole});
    emit selectionChanged();
}

void LogModel::selectRow(int row)
{
    if (row < 0 || row >= m_filteredEntries.count())
        return;
    if (m_selectedRows.size() == 1 && m_selectedRows.contains(row))
        return;
    m_selectedRows.clear();
    m_selectedRows.insert(row);
    notifySelectionChanged();
}

// ==================== 加载 / 过滤 / 搜索 ====================

void LogModel::loadFile(const QString &path)
{
    // QML 的 FileDialog 传过来的是 url 字符串（file:///C:/...），先转本地路径
    const QUrl url(path);
    const QString localPath = url.isLocalFile() ? url.toLocalFile() : path;

    QFile file(localPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "LogModel: 无法打开文件" << localPath << file.errorString();
        return;
    }

    beginResetModel();
    m_allEntries.clear();

    QTextStream in(&file);
    in.setCodec("UTF-8");
    // 两种已知日志格式：
    //  A. "17:56:22.977 [WARN][t:260c] 消息"      （毫秒时间戳 + 方括号级别 + 线程ID）
    //  B. "2026-10-15 12:34:56 [INFO] 消息内容"   （日期时间 + 方括号级别）
    // 都不匹配的兜底：INFO + 整行作 message
    static const QRegularExpression reA(R"(^(\d{1,2}:\d{2}:\d{2}\.\d{3})\s+\[(\w+)\]\[t:[0-9a-fA-F]+\]\s*(.*)$)");
    static const QRegularExpression reB(R"(^(\S+\s+\S+)\s+\[(\w+)\]\s*(.*)$)");

    while (!in.atEnd()) {
        const QString line = in.readLine();
        if (line.isEmpty())
            continue;

        LogEntry entry;
        entry.rawLine = line;

        auto match = reA.match(line);
        if (!match.hasMatch())
            match = reB.match(line);

        if (match.hasMatch()) {
            entry.timestamp = match.captured(1);
            entry.level     = match.captured(2).toUpper();
            entry.message   = match.captured(3);
        } else {
            entry.level   = "INFO";
            entry.message = line;
        }

        // 连续相同行合并：比较 level + message（忽略时间戳，带上时间就没法判定相同）
        if (!m_allEntries.isEmpty()) {
            LogEntry &last = m_allEntries.last();
            if (last.level == entry.level && last.message == entry.message) {
                last.repeatCount += 1;
                last.rawLine += QLatin1Char('\n') + entry.rawLine;   // 详情面板保留全部原始行
                continue;
            }
        }
        m_allEntries.append(entry);
    }
    file.close();

    m_currentLevel   = "ALL";
    m_currentKeyword.clear();
    m_filteredEntries = m_allEntries;
    m_selectedRows.clear();              // 换文件后清空选择

    endResetModel();
    emit countChanged();
    emit selectionChanged();
    updateMatches();
}

void LogModel::filterByLevel(const QString &level)
{
    if (m_currentLevel == level)
        return;
    m_currentLevel = level;
    applyFilter();
}

void LogModel::search(const QString &keyword)
{
    // 搜索不再过滤：只记录关键词、重算命中行，由 delegate 负责高亮
    m_currentKeyword = keyword;
    updateMatches();
}

void LogModel::clear()
{
    beginResetModel();
    m_allEntries.clear();
    m_filteredEntries.clear();
    endResetModel();
    m_selectedRows.clear();
    emit countChanged();
    emit selectionChanged();
    updateMatches();
}

void LogModel::applyFilter()
{
    beginResetModel();
    m_filteredEntries.clear();
    for (const LogEntry &entry : m_allEntries) {
        if (m_currentLevel != "ALL" && entry.level != m_currentLevel)
            continue;
        m_filteredEntries.append(entry);
    }
    m_selectedRows.clear();              // 行号重排，选择作废
    endResetModel();
    emit countChanged();
    emit selectionChanged();
    updateMatches();
}

void LogModel::updateMatches()
{
    m_matchRows.clear();
    if (!m_currentKeyword.isEmpty()) {
        for (int i = 0; i < m_filteredEntries.count(); ++i) {
            if (m_filteredEntries.at(i).rawLine.contains(m_currentKeyword, Qt::CaseInsensitive))
                m_matchRows.append(i);
        }
    }
    emit matchCountChanged();
}
