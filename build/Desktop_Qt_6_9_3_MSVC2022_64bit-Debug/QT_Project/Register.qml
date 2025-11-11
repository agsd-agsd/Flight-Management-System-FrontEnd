import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    property StackView stackView

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        FluCopyableText {
            text: "用户注册"
            font.pixelSize: 24
            Layout.alignment: Qt.AlignHCenter
        }

        FluTextBox {
            id: regUsername
            placeholderText: "用户名"
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignHCenter
        }

        FluPasswordBox {
            id: regPassword
            placeholderText: "密码"
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignHCenter
        }

        FluPasswordBox {
            id: confirmPassword
            placeholderText: "确认密码"
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignHCenter
        }

        FluText {
            id: regError
            color: "red"
            text: ""
            visible: false
            Layout.alignment: Qt.AlignHCenter
        }

        FluButton {
            text: "注册"
            Layout.preferredWidth: 80
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
            var username = regUsername.text.trim()
            var pass = regPassword.text
            var confirm = confirmPassword.text
            console.log("用户名:", username)
            console.log("密码长度:", pass.length)
            console.log("密码确认:", confirm.length)
            if (username === "" || pass.length < 6 || pass !== confirm) {
            regError.text = qsTr("请检查输入（用户名不能为空，密码至少6位且匹配）")
            regError.visible = true
            return
            }
            regError.visible = false
            console.log("验证通过，调用后端")
            networkHandler.registerUser(username, pass)
            }
        }

        FluTextButton {
            text: qsTr("返回登录")
            onClicked: stackView.pop()
            Layout.alignment: Qt.AlignHCenter
        }

        Connections {
        target: networkHandler
        function onRegisterSuccess(message) {
        console.log("注册成功:", message)
        regError.visible = false
        stackView.pop()
        }
        function onRegisterError(error) {
        console.log("注册失败:", error)
        regError.text = error
        regError.visible = true
        }
        }
    }
}
