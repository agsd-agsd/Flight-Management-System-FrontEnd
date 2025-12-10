import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import QT_Project

Item {
    property StackView stackView

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        FluCopyableText {
            text: "AIR"
            font.pixelSize: 24
            Layout.alignment: Qt.AlignHCenter
        }

        FluTextBox {
            id: usernameField
            placeholderText: "邮箱"
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignHCenter
        }

        FluPasswordBox {
            id: passwordField
            placeholderText: "密码"
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignHCenter
        }

        FluText {
            id: errorLabel
            color: "red"
            text: ""
            visible: false
            Layout.alignment: Qt.AlignHCenter
        }

        FluButton {
            id: loginButton
            text: "登录"
            Layout.preferredWidth: 80
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                var email = usernameField.text.trim()
                var password = passwordField.text
                var emailReg=/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
                if (!emailReg.test(email)) {
                     errorLabel.text = qsTr("请输入正确的邮箱地址")
                     errorLabel.visible = true
                     return
                 }
                 if (password.length < 6) {
                     errorLabel.text = qsTr("密码至少6位")
                     errorLabel.visible = true
                     return
                 }
                 errorLabel.visible = false
                 console.log("登录提交:", email)
                 networkHandler.login(email, password)

            }
        }

        Connections {
            target: networkHandler

            function onLoginSuccess(userInfo,msg) {
                console.log("登录成功", msg)
                console.log("用户数据:", JSON.stringify(userInfo))
                // 1. 将数据存入全局单例
                // 注意：确保 UserSession.qml 里有 userid 属性，如果没有可以不存
                GlobalSession.username = userInfo.username
                GlobalSession.email = userInfo.email
                GlobalSession.userid = userInfo.userid
                GlobalSession.isLoggedIn = true

                console.log("【验证】UserSession.email:", GlobalSession.email)
                console.log("【验证】UserSession.userId:", GlobalSession.userId)
                console.log("----------------------------------------------------")

                stackView.push("DashBoard.qml", {stackView: stackView})
            }
            function onLoginError(errmsg) {
                errorLabel.text = errmsg
                errorLabel.visible = true
                console.log("登录失败：", errmsg)
            }
        }

        FluTextButton {
            text: qsTr("没有账户？点击注册")
            onClicked: stackView.push("Register.qml", {stackView: stackView})
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
