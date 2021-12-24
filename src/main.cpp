#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "documenthandler.h"
#include "highlightmodel.h"
#include "texteditor.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    qmlRegisterType<DocumentHandler>("Cutefish.TextEditor", 1, 0, "DocumentHandler");
    qmlRegisterType<FileHelper>("Cutefish.TextEditor", 1, 0, "FileHelper");

    HighlightModel m;

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
