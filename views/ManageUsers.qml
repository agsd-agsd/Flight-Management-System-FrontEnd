import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluContentPage {
    id: root
    title: "用户管理"

    property var navView

    // 数据模型
    property var userModel: ListModel {}
    property int totalCount: 0

    // 列宽比例配置 (ID, 头像, 用户名, 邮箱, 余额, 操作)
    // 邮箱通常比较长，所以给 35%
    property var colRatios: [0.10, 0.10, 0.15, 0.35, 0.15, 0.15]

    // 网络请求处理
    NetworkHandler {
        id: netHandler
        onRequestSuccess: function(res, endpoint){
            // 1. 获取所有用户
            if(endpoint === "/AdminGetAllUsers"){
                if(res.success){
                    userModel.clear()
                    totalCount = res.count || 0
                    if(res.users){
                        for(var i=0; i<res.users.length; i++){
                            userModel.append(res.users[i])
                        }
                    }
                    showSuccess("加载完成，共 " + totalCount + " 名用户")
                } else {
                    showError(res.message || "获取用户列表失败")
                }
            }
            // 2. 删除用户
            else if(endpoint === "/AdminDeleteUser"){
                if(res.success){
                    var msg = "删除成功！"
                    // 如果有退票信息，显示出来，让管理员知道系统自动退了多少票
                    if(res.refundcount > 0){
                        msg += "\n自动退票: " + res.refundcount + " 张"
                        if(res.refundinfo) msg += "\n说明: " + res.refundinfo
                    }
                    showSuccess(msg)

                    deleteDialog.close()
                    refreshList() // 刷新列表
                } else {
                    showError(res.message || "删除失败")
                }
            }
        }
        onRequestFailed: function(err){
            showError("网络错误: " + err)
        }
    }

    // 刷新函数
    function refreshList(){
        // 接口无需参数
        netHandler.request("/AdminGetAllUsers", NetworkHandler.POST, {})
    }

    // 页面加载完成后自动刷新
    Component.onCompleted: refreshList()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        // --- 1. 顶部工具栏 ---
        RowLayout {
            Layout.fillWidth: true
            FluText {
                text: "总用户数: " + totalCount
                font.bold: true
                color: FluTheme.primaryColor
            }
            Item { Layout.fillWidth: true }
            FluButton {
                text: "刷新列表"
                onClicked: refreshList()
            }
        }

        // --- 2. 表头 ---
        Rectangle {
            Layout.fillWidth: true
            height: 45
            color: FluTheme.dark ? "#252525" : "#f0f0f0"
            radius: 4

            Row {
                anchors.fill: parent
                Repeater {
                    model: ["ID", "头像", "用户名", "邮箱", "余额", "操作"]
                    Item {
                        width: parent.width * colRatios[index]
                        height: parent.height
                        FluText {
                            text: modelData
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }
                }
            }
        }

        // --- 3. 用户列表 ---
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: userModel
            spacing: 0 // 不需要间距，用边框分割

            delegate: Rectangle {
                width: ListView.view.width
                height: 60
                color: {
                    if(index % 2 === 0) return "transparent"
                    return FluTheme.dark ? "#2d2d2d" : "#f9f9f9"
                }

                Row {
                    anchors.fill: parent

                    // ID
                    Item {
                        width: parent.width * colRatios[0]
                        height: parent.height
                        FluText { text: model.id; anchors.centerIn: parent }
                    }

                    // 头像 (显示为颜色圆圈)
                    Item {
                        width: parent.width * colRatios[1]
                        height: parent.height
                        Rectangle {
                            width: 36; height: 36
                            radius: 18
                            anchors.centerIn: parent
                            // 使用后端返回的 profile_color，如果没有则灰色
                            color: model.profile_color || "#cccccc"
                            border.color: "#ddd"
                            border.width: 1

                            // 在圆圈中间显示用户名首字母
                            FluText {
                                text: (model.username && model.username.length > 0) ? model.username[0].toUpperCase() : "U"
                                anchors.centerIn: parent
                                color: "white"
                                font.bold: true
                                font.pixelSize: 16
                            }
                        }
                    }

                    // 用户名
                    Item {
                        width: parent.width * colRatios[2]
                        height: parent.height
                        FluText {
                            text: model.username
                            anchors.centerIn: parent
                            elide: Text.ElideRight
                            width: parent.width - 20
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    // 邮箱
                    Item {
                        width: parent.width * colRatios[3]
                        height: parent.height
                        FluText {
                            text: model.email
                            anchors.centerIn: parent
                            elide: Text.ElideRight
                            width: parent.width - 20
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    // 余额
                    Item {
                        width: parent.width * colRatios[4]
                        height: parent.height
                        FluText {
                            text: "¥" + model.currency
                            anchors.centerIn: parent
                            color: "#ff9900"
                            font.bold: true
                        }
                    }

                    // 操作 (删除按钮)
                    Item {
                        width: parent.width * colRatios[5]
                        height: parent.height
                        FluFilledButton {
                            text: "删除"
                            anchors.centerIn: parent
                            width: 80
                            height: 30
                            // 红色背景警告
                            normalColor: "#ff4d4f"
                            hoverColor: "#ff7875"

                            onClicked: {
                                deleteDialog.pendingUserId = model.id
                                deleteDialog.pendingUserName = model.username
                                deleteDialog.open()
                            }
                        }
                    }
                }

                //底部分割线
                Rectangle {
                    width: parent.width
                    height: 1
                    color: FluTheme.dark ? "#333" : "#eee"
                    anchors.bottom: parent.bottom
                }
            }
        }
    }

    // --- 4. 删除确认弹窗 ---
    FluContentDialog {
        id: deleteDialog
        title: "高风险操作确认"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        negativeText: "取消"
        positiveText: "确认删除"

        // 暂存要删除的用户信息
        property int pendingUserId: -1
        property string pendingUserName: ""

        message: "您确定要删除用户 [" + pendingUserName + "] (ID: " + pendingUserId + ") 吗？\n\n注意：此操作不可恢复！该用户的所有未出行订单将被强制退票。"

        onPositiveClicked: {
            if(pendingUserId !== -1){
                netHandler.request("/AdminDeleteUser", NetworkHandler.POST, {
                    userid: parseInt(pendingUserId)
                })
            }
        }
    }
}
