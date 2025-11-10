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
            text: "注册新账户"
            font.pixelSize: 24
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }

        FluTextBox { id: regUsername; placeholderText: "用户名"; Layout.preferredWidth: 200; Layout.alignment: Qt.AlignHCenter }
        FluTextBox { id: emailField; placeholderText: "邮箱"; Layout.preferredWidth: 200; Layout.alignment: Qt.AlignHCenter }
        FluPasswordBox { id: regPassword; placeholderText: "密码"; Layout.preferredWidth: 200; Layout.alignment: Qt.AlignHCenter }
        FluPasswordBox { id: confirmPassword; placeholderText: "确认密码"; Layout.preferredWidth: 200; Layout.alignment: Qt.AlignHCenter }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10
            FluButton {
                text: "注册"
                Layout.preferredWidth: 80
                onClicked: {
                    // TODO: 验证 + API 调用
                    if (regPassword.text !== confirmPassword.text) {
                        console.log("密码不匹配");
                        return;
                    }
                    console.log("注册提交: " + regUsername.text);
                    // stackView.push("MainDashboard.qml");  // 成功后跳转主页面
                }
            }
        }

        FluTextButton {
            text: "已有账户？返回登录"
            onClicked: stackView.pop()
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
