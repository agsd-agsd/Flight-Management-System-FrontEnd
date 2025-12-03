#include "apiH/networkhandler.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray> // [新增]
#include <QUrl>
#include <QUrlQuery> // [新增]
#include <QNetworkRequest>
#include <QDebug>
#include <QSslError>
#include <QJsonParseError>
#include <QSslSocket>

NetworkHandler::NetworkHandler(QObject *parent)
    : QObject(parent),
    m_networkManager(new QNetworkAccessManager(this))
{
    // [新增] 初始化基地址
    m_baseUrl = "https://sixonezero.goutou.space";
    qDebug() << "[NetworkHandler] constructed. SSL supported? " << QSslSocket::supportsSsl();
}


// [新增] 通用请求实现
void NetworkHandler::request(const QString &apiPath, Method method, const QVariantMap &params, const QString &token)
{
    // 1. 拼接 URL (使用基地址 + 传入的 API 路径)
    QString fullUrlStr = m_baseUrl + apiPath;

    // 如果是 GET 请求且有参数，拼接到 URL 后面
    if (method == GET && !params.isEmpty()) {
        QUrlQuery query;
        for (auto it = params.begin(); it != params.end(); ++it) {
            query.addQueryItem(it.key(), it.value().toString());
        }
        fullUrlStr += "?" + query.toString();
    }

    QUrl url(fullUrlStr);
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    req.setTransferTimeout(15000); // 统一超时设置

    // 2. 如果有 Token，设置 Header
    if (!token.isEmpty()) {
        req.setRawHeader("Authorization", ("Bearer " + token).toUtf8());
    }

    qDebug() << "[NetworkHandler] Generic Request:" << (method == GET ? "GET" : "POST") << url;

    // 3. 发送请求
    QNetworkReply *reply = nullptr;
    if (method == GET) {
        reply = m_networkManager->get(req);
    } else {
        // POST: 将参数转为 JSON
        QJsonObject json = QJsonObject::fromVariantMap(params);
        QJsonDocument doc(json);
        reply = m_networkManager->post(req, doc.toJson(QJsonDocument::Compact));
    }

    // 4. 处理响应
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        // 先获取状态码
        int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        QString errorString = reply->errorString();

        qDebug() << "[NetworkHandler] HTTP Status:" << statusCode;

        // 【关键修改】如果出错了（Status 0 或其他错误），不要强行 readAll，否则会报 device not open
        if (reply->error() != QNetworkReply::NoError) {
            qDebug() << "[NetworkHandler] ❌ 请求失败 (网络层):" << errorString;

            // 如果不是 0 (比如 400/500)，尝试读一下服务器有没有返回错误详情
            if (reply->isOpen() && statusCode > 0) {
                QByteArray errorBody = reply->readAll();
                qDebug() << "[NetworkHandler] 服务器错误详情:" << errorBody;
                emit requestFailed("服务器拒绝: " + errorBody);
            } else {
                // 如果是 0 (直接断网/SSL错误)，直接报网络错
                emit requestFailed("网络连接失败: " + errorString);
            }

            reply->deleteLater();
            return;
        }

        QByteArray resp = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(resp);

        // 简单判断 JSON 有效性
        if (doc.isNull()) {
            emit requestFailed("服务器返回无效数据");
            return;
        }

        // 成功！将 JSON 转为 QVariant 发回给 QML
        if (doc.isObject()) {
            emit requestSuccess(doc.object().toVariantMap());
        } else if (doc.isArray()) {
            emit requestSuccess(doc.array().toVariantList());
        } else {
            emit requestSuccess(QVariant());
        }
    });

    // 简单 SSL 处理
    connect(reply, &QNetworkReply::sslErrors, reply, [reply](){
        reply->ignoreSslErrors();
    });
}



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
