#include "usersession.h"

// 1. 初始化静态成员变量 (必须在类外部，且在cpp文件中)
UserSession* UserSession::m_instance = nullptr;

// 2. 实现 instance() 方法
UserSession* UserSession::instance()
{
    if (m_instance == nullptr) {

        m_instance = new UserSession(nullptr);
    }
    return m_instance;
}
