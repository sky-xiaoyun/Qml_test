#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "LogModel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    // QSettings 需要组织标识（FileDialog 记住上次目录）
    app.setOrganizationName("QmlTest");
    app.setApplicationName("LogViewer");

    // LogModel 注册为 QML 类型，在 main.qml 里以 LogModel { id: logModel } 实例化
    qmlRegisterType<LogModel>("com.demo", 1, 0, "LogModel");

    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
