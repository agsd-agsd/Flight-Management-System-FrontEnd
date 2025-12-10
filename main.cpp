#include "apiH/networkhandler.h"
#include "animationH/CircularReveal.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QCoreApplication>
#include <QQmlEngine>
#include "UserSession.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    NetworkHandler *handler = new NetworkHandler(&app);
    engine.rootContext()->setContextProperty("networkHandler", handler);

    qmlRegisterType<NetworkHandler>("NetworkHandler", 1, 0, "NetworkHandler");
    qmlRegisterType<CircularReveal>("AppComponents", 1, 0, "CircularReveal");


    UserSession *session = UserSession::instance();
    engine.rootContext()->setContextProperty("GlobalSession", session);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
        );

    engine.loadFromModule("QT_Project", "MainWindow");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
