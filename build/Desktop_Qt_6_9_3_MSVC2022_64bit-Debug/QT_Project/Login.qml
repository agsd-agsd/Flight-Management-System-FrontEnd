import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    property StackView stackView

    Rectangle {
        anchors.fill: parent
        color: "black"  // 保留原有背景
    }

    FluContentDialog {
        id: exitDialog
        title: qsTr("友情提示")
        message: qsTr("确定要退出吗？")
        negativeText: qsTr("取消")
        positiveText: qsTr("确定")
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        width: 300

        onNegativeClicked: {
            // 取消时，可以显示提示或直接关闭
            console.log("点击了取消按钮")
            // 如果有showSuccess函数，可以用：showSuccess(qsTr("点击了取消按钮"))
            exitDialog.close()  // 确保关闭对话框
        }

        onPositiveClicked: {
            // 确定退出
            console.log("点击了确定按钮")
            // 如果有showSuccess函数，可以用：showSuccess(qsTr("点击了确定按钮"))
            exitDialog.close()  // 关闭对话框
            Qt.quit()  // 执行退出应用
        }
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
        RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                FluButton {
                    id: loginButton
                    text: "登录"
                    Layout.preferredWidth: 80
                    Layout.alignment: Qt.AlignHCenter
                }

                FluButton {
                    text: "退出"  // 新增退出按钮
                    Layout.preferredWidth: 80
                    onClicked: {
                        exitDialog.open()
                    }
                }
        }

        FluTextButton {
            text: "没有账户？点击注册"  // 保留原有按钮，假设这是注册入口
            onClicked: {
                stackView.push("Register.qml", {stackView: stackView})
            }
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
