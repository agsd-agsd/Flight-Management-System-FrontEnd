#ifndef NETWORKHANDLER_H
#define NETWORKHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QString>

class NetworkHandler : public QObject
{
    Q_OBJECT

public:
    explicit NetworkHandler(QObject *parent = nullptr);

    Q_INVOKABLE void login(const QString &email, const QString &password);
    Q_INVOKABLE void registerUser(const QString &email, const QString &username, const QString &password);

signals:
    void loginSuccess(const QString &message);
    void loginError(const QString &error);
    void registerSuccess(const QString &message);
    void registerError(const QString &error);

private:
    QNetworkAccessManager *m_networkManager;
};

#endif // NETWORKHANDLER_H
