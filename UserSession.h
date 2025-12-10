#ifndef USERSESSION_H
#define USERSESSION_H

#include <QObject>

class UserSession : public QObject
{
    Q_OBJECT
    // 定义 QML 可访问的属性
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(int userId READ userId WRITE setUserId NOTIFY userIdChanged)
    Q_PROPERTY(bool isLoggedIn READ isLoggedIn WRITE setIsLoggedIn NOTIFY isLoggedInChanged)

public:
    explicit UserSession(QObject *parent = nullptr)
        : QObject(parent)
        , m_username("")
        , m_email("")
        , m_userId(0)
        , m_isLoggedIn(false)
    {}
    static UserSession *instance();

    // Getter 方法
    QString username() const { return m_username; }
    QString email() const { return m_email; }
    int userId() const { return m_userId; }
    bool isLoggedIn() const { return m_isLoggedIn; }

    // Setter 方法 (QML赋值时会自动调用这些)
    void setUsername(const QString &name) {
        if (m_username != name) {
            m_username = name;
            emit usernameChanged();
        }
    }
    void setEmail(const QString &mail) {
        if (m_email != mail) {
            m_email = mail;
            emit emailChanged();
        }
    }
    void setUserId(const int &id) { // 为了方便，ID统一用String存
        if (m_userId != id) {
            m_userId = id;
            emit userIdChanged();
        }
    }
    void setIsLoggedIn(bool status) {
        if (m_isLoggedIn != status) {
            m_isLoggedIn = status;
            emit isLoggedInChanged();
        }
    }

signals:
    void usernameChanged();
    void emailChanged();
    void userIdChanged();
    void isLoggedInChanged();

private:
    static UserSession *m_instance;
    QString m_username;
    QString m_email;
    int m_userId;
    bool m_isLoggedIn;
};

#endif // USERSESSION_H
