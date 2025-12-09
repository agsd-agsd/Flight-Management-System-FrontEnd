import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluContentPage {
    id: root
    title: "个人中心"

    property var stackView // 接收外层 StackView 用于退出登录
    property var navView

    // 模拟用户信息
    property string userId: "90001"
    property string userName: "Admin"
    property color avatarColor: "#0078d4"
    property var colorList: ["#0078d4", "#107c10", "#d13438", "#5c2d91", "#ff8c00", "#00b7c3"]

    FluContentDialog {
        id: logoutDialog
        title: "退出登录"
        message: "确定要退出当前账号吗？"
        negativeText: "取消"
        positiveText: "确定退出"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        onPositiveClicked: {
            showSuccess("已退出登录")
            if (stackView) {
                stackView.pop()
            }
        }
    }

    FluContentDialog {
        id: deleteAccountDialog
        title: "注销账号"
        message: "警告：注销账号将永久删除您的所有数据（订单、收藏等），此操作不可恢复！\n\n确定要继续吗？"
        negativeText: "取消"
        positiveText: "确认注销"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        onPositiveClicked: {
            showSuccess("账号已注销")
            if (stackView) {
                stackView.pop()
            }
        }
    }

    // FluContentDialog {
    //     id: colorPickerDialog
    //     ...
    // }

    ScrollView {
        anchors.fill: parent
        contentWidth: parent.width

        ColumnLayout {
            width: Math.min(parent.width, 600)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 40
            spacing: 30

            // 头像区域
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 15

                FluRectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 120
                    height: 120
                    radius: [60,60,60,60]
                    color: avatarColor
                    
                    FluText {
                        anchors.centerIn: parent
                        text: userName.length > 0 ? userName.charAt(0).toUpperCase() : "U"
                        font.pixelSize: 48
                        color: "white"
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            // 随机切换颜色
                            var nextIndex = Math.floor(Math.random() * colorList.length)
                            avatarColor = colorList[nextIndex]
                            showInfo("头像颜色已更新")
                        }
                    }
                }
                
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10
                    
                    FluText {
                        text: "自定义颜色:"
                        color: "#888888"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }

                    FluColorPicker {
                        id: avatarColorPicker
                        current: root.avatarColor
                        onAccepted: {
                            root.avatarColor = current
                            showSuccess("头像颜色已更新")
                        }
                    }
                }
                
                FluText {
                    text: "点击头像随机切换颜色"
                    color: "#888888"
                    font.pixelSize: 12
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // 信息编辑区域
            FluRectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                radius: [8,8,8,8]
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
                borderWidth: 1
                borderColor: "#e0e0e0"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20

                    FluText {
                        text: "基本信息"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 15
                        FluText { 
                            text: "用户 ID:" 
                            Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox {
                            Layout.fillWidth: true
                            text: userId
                            placeholderText: "请输入用户ID"
                            onTextChanged: userId = text
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 15
                        FluText { 
                            text: "用户名:" 
                            Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter
                        }
                        FluTextBox {
                            Layout.fillWidth: true
                            text: userName
                            placeholderText: "请输入用户名"
                            onTextChanged: userName = text
                        }
                    }

                    FluFilledButton {
                        text: "保存修改"
                        Layout.alignment: Qt.AlignRight
                        onClicked: {
                            showSuccess("个人信息保存成功")
                        }
                    }
                }
            }

            // 账号操作区域
            FluRectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                radius: [8,8,8,8]
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
                borderWidth: 1
                borderColor: "#e0e0e0"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20

                    FluText {
                        text: "账号安全"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 20

                        FluButton {
                            text: "退出登录"
                            Layout.fillWidth: true
                            onClicked: {
                                logoutDialog.open()
                            }
                        }

                        FluButton {
                            text: "注销账号"
                            textColor: "#ff4d4f"
                            Layout.fillWidth: true
                            onClicked: {
                                deleteAccountDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }
}
