#ifndef NETWORKHANDLER_H
#define NETWORKHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QString>
#include <QVariantMap> // [新增] 用于通用参数

class NetworkHandler : public QObject
{
    Q_OBJECT

public:
    explicit NetworkHandler(QObject *parent = nullptr);

    // [新增] 通用功能部分
    enum Method {
        GET,
        POST
    };
    Q_ENUM(Method) // 注册枚举给 QML

    // 通用请求函数
    Q_INVOKABLE void request(const QString &apiPath, Method method, const QVariantMap &params = {}, const QString &token = "");


    Q_INVOKABLE void login(const QString &email, const QString &password);
    Q_INVOKABLE void registerUser(const QString &email, const QString &username, const QString &password);

signals:
    // [新增] 通用信号
    void requestSuccess(const QVariant &responseData); // 返回 JSON 数据给 QML
    void requestFailed(const QString &errorMessage);   // 返回错误信息


    void loginSuccess(const QVariantMap &userInfo, const QString &msg);
    void loginError(const QString &error);
    void registerSuccess(const QString &message);
    void registerError(const QString &error);

private:
    QNetworkAccessManager *m_networkManager;
    QString m_baseUrl;
};

#endif // NETWORKHANDLER_H
