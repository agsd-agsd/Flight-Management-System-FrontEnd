import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluScrollablePage {
    id: root
    title: "个人中心"

    property var stackView // 接收外层 StackView 用于退出登录
    property var navView
    property var favoritesModel
    property var ordersModel
    property string userEmail: GlobalSession.email
    property string userName: GlobalSession.username

    function toHexColor(c) {
        var colorStr = c.toString()
        if (colorStr.startsWith("#")) {
            colorStr = colorStr.substring(1)
        }
        if (colorStr.length === 6) {
            colorStr = "FF" + colorStr
        }
        return colorStr.toUpperCase()
    }

    // 模拟用户信息
    property string userId: GlobalSession.userId.toString()
    // property string userName: "Admin" // Removed to avoid conflict
    property color avatarColor: {
        if (GlobalSession.profileColor && GlobalSession.profileColor !== "") {
            return GlobalSession.profileColor
        }
        return "#0078d4"
    }
    property var colorList: ["#0078d4", "#107c10", "#d13438", "#5c2d91", "#ff8c00", "#00b7c3"]

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(res, endpoint){
            if(endpoint === "/GetCurrency"){
                if(res.currency !== undefined) {
                    GlobalSession.balance = parseFloat(res.currency)
                }
            } else if (endpoint === "/UpdateProfileColor") {
                showSuccess("头像颜色已更新")
            } else if (endpoint === "/UpdateUsername") {
                showSuccess("用户名已更新")
                GlobalSession.username = userName
            }
        }
        onRequestFailed: function(errMsg) {
            // 尝试提取 JSON 错误信息
            var displayMsg = errMsg
            if (errMsg.indexOf("服务器拒绝: ") !== -1) {
                var jsonStr = errMsg.replace("服务器拒绝: ", "")
                try {
                    var jsonObj = JSON.parse(jsonStr)
                    if (jsonObj.errors) {
                        displayMsg = jsonObj.errors
                    }
                } catch(e) {
                    // 解析失败，使用原始消息
                }
            }
            showError(displayMsg)
        }
    }

    onVisibleChanged: {
        if(visible) {
            // 页面可见时同步数据，防止因缓存导致显示旧数据
            userName = GlobalSession.username
            
            // 刷新余额
            networkHandler.request("/GetCurrency", NetworkHandler.POST, {
                email: GlobalSession.email,
                id: GlobalSession.userId
            })
        }
    }



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


    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        width: Math.min(parent.width, 600)
        Layout.topMargin: 20
        spacing: 30

        // 钱包按钮区域
        Item {
            Layout.fillWidth: true
            height: 40
            FluFilledButton {
                text: "我的钱包"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    navView.push("qrc:/qt/QT_Project/views/RechargeView.qml", {
                        navView: navView,
                        userEmail: root.userEmail
                    })
                }
            }
        }

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
                            var newColor = colorList[nextIndex]
                            
                            // Update Global Session
                            GlobalSession.profileColor = newColor
                            
                            // Call API
                            networkHandler.request("/UpdateProfileColor", NetworkHandler.POST, {
                                email: GlobalSession.email,
                                id: GlobalSession.userId,
                                profile_color: toHexColor(newColor)
                            })
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
                            var newColor = current
                            GlobalSession.profileColor = newColor
                            
                            networkHandler.request("/UpdateProfileColor", NetworkHandler.POST, {
                                email: GlobalSession.email,
                                id: GlobalSession.userId,
                                profile_color: toHexColor(newColor)
                            })
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
                            if (userName === "") {
                                showError("用户名不能为空")
                                return
                            }
                            
                            networkHandler.request("/UpdateUsername", NetworkHandler.POST, {
                                email: GlobalSession.email,
                                id: GlobalSession.userId,
                                new_username: userName
                            })
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
                    }
                }
            }
        }
    }
