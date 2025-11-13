#include "networkhandler.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QNetworkRequest>
#include <QDebug>
#include <QSslError>
#include <QJsonParseError>
#include <QSslSocket>

NetworkHandler::NetworkHandler(QObject *parent)
    : QObject(parent),
    m_networkManager(new QNetworkAccessManager(this))
{
    qDebug() << "[NetworkHandler] constructed. SSL supported? " << QSslSocket::supportsSsl();
}

// 登录：真实 POST 到 /Login，使用邮箱和密码
void NetworkHandler::login(const QString &email, const QString &password)
{
    qDebug() << "[NetworkHandler] login called with email:" << email;

    // 准备 URL（后端给的基地址）
    QUrl url("https://sixonezero.goutou.space/Login");
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    req.setTransferTimeout(15000);  // 15 秒超时，防挂起

    // JSON body：使用邮箱和密码
    QJsonObject body;
    body["email"] = email;
    body["password"] = password;

    // 使用 Compact 模式：无换行/缩进，确保 JSON 格式正确
    QByteArray payload = QJsonDocument(body).toJson(QJsonDocument::Compact);
    qDebug() << "[NetworkHandler] POST" << url << "payload:" << payload;

    QNetworkReply *reply = m_networkManager->post(req, payload);

    // 详细错误日志（包括 HTTP 状态码）
    connect(reply, &QNetworkReply::errorOccurred, this, [reply](QNetworkReply::NetworkError code) {
        qDebug() << "[NetworkHandler] Network error code:" << code << "(" << reply->errorString() << ")";
        qDebug() << "[NetworkHandler] HTTP status:" << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    });

    // 处理完成回调
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        qDebug() << "[NetworkHandler] HTTP status code:" << statusCode;

        if (reply->error() != QNetworkReply::NoError) {
            QString err = reply->errorString();
            qDebug() << "[NetworkHandler] login network error:" << err;
            emit loginError("网络连接失败 (HTTP " + QString::number(statusCode) + "): " + err);
            reply->deleteLater();
            return;
        }

        QByteArray resp = reply->readAll();
        qDebug() << "[NetworkHandler] login raw response:" << resp;

        QJsonParseError parseErr;
        QJsonDocument doc = QJsonDocument::fromJson(resp, &parseErr);
        if (parseErr.error != QJsonParseError::NoError || !doc.isObject()) {
            qDebug() << "[NetworkHandler] JSON parse error:" << parseErr.errorString();
            emit loginError("服务器响应无效 (解析失败): " + parseErr.errorString());
            reply->deleteLater();
            return;
        }

        QJsonObject obj = doc.object();
        bool success = obj["success"].toBool();
        if (success) {
            QString msg = obj["message"].toString();
            qDebug() << "[NetworkHandler] login success:" << msg;
            // 可选：存储 userid, email, username 到成员变量或信号中传递
            emit loginSuccess(msg);
        } else {
            QString err;
            if (obj.contains("errors")) {
                if (obj["errors"].isString()) err = obj["errors"].toString();
                else err = QJsonDocument(obj["errors"].toObject()).toJson(QJsonDocument::Compact);
            } else {
                err = obj["message"].toString();
            }
            qDebug() << "[NetworkHandler] login returned error:" << err;
            emit loginError("登录失败: " + err);
        }

        reply->deleteLater();
    });

    // SSL 错误处理
    connect(reply, &QNetworkReply::sslErrors, this, [this, reply](const QList<QSslError> &errors){
        qDebug() << "[NetworkHandler] SSL errors during login:";
        for (const QSslError &e : errors) qDebug() << " - " << e.errorString();
        emit loginError("SSL 证书问题，无法连接服务器");
        reply->abort();
    });
}

// 注册：真实 POST 到 /Register，使用邮箱、用户名、密码
void NetworkHandler::registerUser(const QString &email, const QString &username, const QString &password)
{
    qDebug() << "[NetworkHandler] register called with email:" << email << "username:" << username;

    // 准备 URL（后端给的基地址）
    QUrl url("https://sixonezero.goutou.space/Register");
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    req.setTransferTimeout(15000);  // 15 秒超时，防挂起

    // JSON body：使用邮箱、用户名、密码
    QJsonObject body;
    body["email"] = email;
    body["username"] = username;
    body["password"] = password;

    // 使用 Compact 模式：无换行/缩进，确保 JSON 格式正确
    QByteArray payload = QJsonDocument(body).toJson(QJsonDocument::Compact);
    qDebug() << "[NetworkHandler] POST" << url << "payload:" << payload;

    QNetworkReply *reply = m_networkManager->post(req, payload);

    // 详细错误日志（包括 HTTP 状态码）
    connect(reply, &QNetworkReply::errorOccurred, this, [reply](QNetworkReply::NetworkError code) {
        qDebug() << "[NetworkHandler] Network error code:" << code << "(" << reply->errorString() << ")";
        qDebug() << "[NetworkHandler] HTTP status:" << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    });

    // 处理完成回调
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        qDebug() << "[NetworkHandler] HTTP status code:" << statusCode;

        if (reply->error() != QNetworkReply::NoError) {
            QString err = reply->errorString();
            qDebug() << "[NetworkHandler] register network error:" << err;
            emit registerError("网络连接失败 (HTTP " + QString::number(statusCode) + "): " + err);
            reply->deleteLater();
            return;
        }

        QByteArray resp = reply->readAll();
        qDebug() << "[NetworkHandler] register raw response:" << resp;

        QJsonParseError parseErr;
        QJsonDocument doc = QJsonDocument::fromJson(resp, &parseErr);
        if (parseErr.error != QJsonParseError::NoError || !doc.isObject()) {
            qDebug() << "[NetworkHandler] JSON parse error:" << parseErr.errorString();
            emit registerError("服务器响应无效 (解析失败): " + parseErr.errorString());
            reply->deleteLater();
            return;
        }

        QJsonObject obj = doc.object();
        bool success = obj["success"].toBool();
        if (success) {
            QString msg = obj["message"].toString();
            qDebug() << "[NetworkHandler] register success:" << msg;
            emit registerSuccess(msg);
        } else {
            QString err;
            if (obj.contains("errors")) {
                if (obj["errors"].isString()) err = obj["errors"].toString();
                else err = QJsonDocument(obj["errors"].toObject()).toJson(QJsonDocument::Compact);
            } else {
                err = obj["message"].toString();
            }
            qDebug() << "[NetworkHandler] register returned error:" << err;
            emit registerError("注册失败: " + err);
        }

        reply->deleteLater();
    });

    // SSL 错误处理
    connect(reply, &QNetworkReply::sslErrors, this, [this, reply](const QList<QSslError> &errors){
        qDebug() << "[NetworkHandler] SSL errors during register:";
        for (const QSslError &e : errors) qDebug() << " - " << e.errorString();
        emit registerError("SSL 证书问题，无法连接服务器");
        reply->abort();
    });
}
