#include "networkhandler.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QCoreApplication>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    NetworkHandler *handler = new NetworkHandler(&app);
    engine.rootContext()->setContextProperty("networkHandler", handler);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
        );

    engine.loadFromModule("QT_Project", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
