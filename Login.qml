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

    FluContentDialog {
        id: exitDialog
        title: qsTr("友情提示")
        message: qsTr("确定要退出吗？")
        negativeText: qsTr("取消")
        positiveText: qsTr("确定")
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        width: 300

        onNegativeClicked: { console.log("取消"); exitDialog.close() }
        onPositiveClicked: { console.log("退出"); exitDialog.close(); Qt.quit() }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        FluCopyableText {
            text: "AIR"
            font.pixelSize: 24
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }

        FluTextBox {
            id: usernameField
            placeholderText: "用户名"
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

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            FluButton {
                id: loginButton
                text: "登录"
                Layout.preferredWidth: 80
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
                    stackView.push(dashboardPage)
                }
            }

            FluButton {
                text: "退出"
                Layout.preferredWidth: 80
                onClicked: exitDialog.open()
            }
        }

        FluTextButton {
            text: qsTr("没有账户？点击注册")
            onClicked: stackView.push("Register.qml", {stackView: stackView})
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
