import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    property StackView stackView

    // 修改：绑定 FluentUI 主题背景（默认深色/浅色自适应）
    Rectangle {
        anchors.fill: parent
        color: FluTheme.windowBackgroundColor
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        FluCopyableText {
            text: "用户注册"
            font.pixelSize: 24
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }

        FluTextBox {
            id: regUsername
            placeholderText: "用户名"
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignHCenter
        }

        FluTextBox {
            id: emailField
            placeholderText: "邮箱"
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
                var email = emailField.text.trim()
                var pass = regPassword.text
                var confirm = confirmPassword.text
                if (username === "" || !email.includes("@") || pass.length < 6 || pass !== confirm) {
                    regError.text = qsTr("请检查输入（密码匹配、邮箱格式）")
                    regError.visible = true
                    return
                }
                regError.visible = false
                console.log("注册提交:", username)
                stackView.pop()
            }
        }

        FluTextButton {
            text: qsTr("返回登录")
            onClicked: stackView.pop()
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
