#include "networkhandler.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QNetworkRequest>
#include <QDebug>

NetworkHandler::NetworkHandler(QObject *parent)
    : QObject(parent),
    m_networkManager(new QNetworkAccessManager(this))
{
    connect(m_networkManager, &QNetworkAccessManager::finished,
            this, &NetworkHandler::handleReply);
}

Q_INVOKABLE void NetworkHandler::login(const QString &username, const QString &password)
{
    qDebug() << "Login called with username:" << username;

    // Mock实现：硬码成功（后期替换为真POST）
    QJsonObject mockResponse;
    mockResponse["success"] = true;
    mockResponse["message"] = "Mock login success";

    emit loginSuccess(mockResponse["message"].toString());
}

Q_INVOKABLE void NetworkHandler::registerUser(const QString &username, const QString &password)
{
    qDebug() << "Register called with username:" << username;

    // Mock实现：硬码成功（后期替换为真POST）
    QJsonObject mockResponse;
    mockResponse["success"] = true;
    mockResponse["message"] = "Mock register success";

    emit registerSuccess(mockResponse["message"].toString());
}

void NetworkHandler::handleReply(QNetworkReply *reply)
{
    // 私有槽：统一处理回复（真HTTP用）

    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << "Network error:" << reply->errorString();
        reply->deleteLater();
        return;
    }

    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);

    if (doc.isNull()) {
        qDebug() << "Invalid JSON";
        reply->deleteLater();
        return;
    }

    QJsonObject obj = doc.object();
    bool success = obj["success"].toBool();
    QString message = obj["message"].toString();
    QJsonValue errors = obj["errors"];

    if (success) {
        qDebug() << "Success:" << message;
        // 示例：emit loginSuccess(message); // 区分action
    } else {
        QString errorMsg = errors.isString() ? errors.toString() : message;
        qDebug() << "Error:" << errorMsg;
        // 示例：emit loginError(errorMsg);
    }

    reply->deleteLater();
}
