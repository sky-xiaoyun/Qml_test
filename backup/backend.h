#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>

class Backend : public QObject
{
    Q_OBJECT
    // 通道②：属性暴露。READ getter / WRITE setter / NOTIFY 变化信号，三件套
    Q_PROPERTY(int counter READ counter WRITE setCounter NOTIFY counterChanged)
    // 只读派生属性：跟着 counter 变，复用同一个 NOTIFY 信号
    Q_PROPERTY(QString statusText READ statusText NOTIFY counterChanged)

public:
    explicit Backend(QObject *parent = nullptr) : QObject(parent), m_counter(0) {}

    int counter() const { return m_counter; }

    QString statusText() const {
        return m_counter > 0 ? QStringLiteral("已计数 %1 次").arg(m_counter)
                             : QStringLiteral("等待点击");
    }

    // 通道③：Q_INVOKABLE —— 标注了 QML 才能调（public slots 同理）
    Q_INVOKABLE void increment() { setCounter(m_counter + 1); }
    Q_INVOKABLE void reset() { setCounter(0); }

public slots:
    void setCounter(int value) {              // WRITE 指定的 setter
        if (value != m_counter) {
            m_counter = value;
            emit counterChanged(m_counter);   // NOTIFY 信号：必须发！
        }
    }

signals:
    void counterChanged(int value);           // NOTIFY 指定的信号

private:
    int m_counter;
};

#endif // BACKEND_H
