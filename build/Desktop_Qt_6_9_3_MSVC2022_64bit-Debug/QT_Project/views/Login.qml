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
                var username = usernameField.text.trim()
                var password = passwordField.text
                if (username === "" || password.length < 6) {
                    errorLabel.text = qsTr("用户名不能为空，密码至少6位")
                    errorLabel.visible = true
                    return
                }
                errorLabel.visible = false
                console.log("登录提交:", username)
                stackView.push("DashBoard.qml", {stackView: stackView})
            }
        }

        FluTextButton {
            text: qsTr("没有账户？点击注册")
            onClicked: stackView.push("Register.qml", {stackView: stackView})
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
