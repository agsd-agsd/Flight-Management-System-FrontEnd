import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluPage {
    id: page

    property var navView
    property var stackView
    property string userEmail: ""
    property string userId: ""
    property int ticketId: 0

    // 详情数据（初始为空，等待接口返回）
    property string flightNo: "--"
    property string depart: "--"
    property string arrive: "--"
    property string departTime: "--:--"
    property string arriveTime: "--:--"
    property string cabin: "经济舱"
    property string seat: "待选"
    property string passengerName: "待定"
    property real price: 0.0

    // 网络请求组件
    NetworkHandler {
        id: detailHandler
        onRequestSuccess: function(res) {
            console.log("【TicketDetails】详情返回:", JSON.stringify(res))
            if (res.success) {
                // 更新界面数据
                flightNo = res.flightnumber || "--"
                depart = res.departureairport || "--"
                arrive = res.arrivalairport || "--"
                departTime = formatTimeStr(res.departuretime)
                arriveTime = formatTimeStr(res.arrivaltime)
                price = res.price || 0
                // 如果后端返回了 ticketid，也可以更新
                if (res.ticketid) ticketId = res.ticketid
            } else {
                showError("获取详情失败: " + (res.message || "未知错误"))
            }
        }
        onRequestFailed: function(err) {
            showError("网络错误: " + err)
        }
    }

    // 辅助函数:转换时间
    function formatTimeStr(rawStr) {
        if (!rawStr) return "--:--"
        var date = new Date(rawStr)
        return Qt.formatTime(date, "hh:mm")
    }

    Component.onCompleted: {
        if (ticketId !== 0) {
            console.log("正在请求票务详情, ID:", ticketId)
            var params = {
                "email": userEmail,
                "id": parseInt(userId),
                "ticketid": ticketId
            }
            // 假设接口路径为 /GetTicketDetails，请根据实际情况修改
            detailHandler.request("/GetTicketDetails", NetworkHandler.POST, params)
        }
    }

    // 二维码配置（最小集成）
    property string qrText: flightNo + "|" + ticketId
    property color qrColor: "#000000"
    property int qrBaseSize: 140

    // 响应式尺寸因子
    property real w: width
    property real scale: Math.max(0.9, Math.min(1.4, w / 1000))
    function fitWidth(base, max) { return Math.min(w - 64, Math.min(max, base * scale)) }

    header: Rectangle {
        height: 56
        color: "transparent"
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12
            Text {
                text: "机票详情"
                color: "#ffffff"
                font.pixelSize: 18 * scale
                font.bold: true
                Layout.fillWidth: true
            }
            FluButton {
                text: "返回航班列表"
                onClicked: {
                    // 尝试使用 StackView 附加属性返回
                    if (page.StackView.view) {
                        page.StackView.view.pop()
                        return
                    }
                    // 尝试使用 navView.pop()
                    if (navView && typeof navView.pop === 'function') {
                        navView.pop()
                        return
                    }
                    console.log("Return failed: No valid pop method found")
                }
            }
        }
    }

    // 统一的 Column 环境（不滚动）
    contentItem: Column {
        id: rootCol
        width: Math.min(parent.width, 1200)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 16
        spacing: 20 * scale

        // 票号卡片
        Rectangle {
            width: fitWidth(800, 1000)
            height: 64 * scale
            radius: 10
            color: "#262626"
            border.color: "#404040"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                anchors.centerIn: parent
                text: "票号: " + ticketId
                color: "white"
                font.pixelSize: 22 * scale
                font.bold: true
            }
        }

        // 航线条（出发 → 到达）
        Rectangle {
            width: fitWidth(900, 1100)
            height: 96 * scale
            radius: 12
            color: "#303030"
            border.color: "#454545"
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16 * scale
                spacing: 20 * scale

                ColumnLayout {
                    spacing: 6 * scale
                    Layout.fillWidth: true
                    Text { text: depart; color: "#ffffff"; font.pixelSize: 18 * scale; font.bold: true }
                    Text { text: departTime; color: "#cccccc"; font.pixelSize: 14 * scale }
                }

                Rectangle {
                    width: 60 * scale; height: 40 * scale; radius: 20 * scale
                    color: "#505050"
                    Layout.preferredWidth: width
                    Layout.preferredHeight: height
                    Text {
                        anchors.centerIn: parent
                        text: "→"
                        color: "white"
                        font.pixelSize: 22 * scale
                    }
                }

                ColumnLayout {
                    spacing: 6 * scale
                    Layout.fillWidth: true
                    Text { text: arrive; color: "#ffffff"; font.pixelSize: 18 * scale; font.bold: true }
                    Text { text: arriveTime; color: "#cccccc"; font.pixelSize: 14 * scale }
                }
            }
        }

        // 标签区：航班号 / 舱位 / 座位
        RowLayout {
            spacing: 12 * scale
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: [
                    "航班号: " + flightNo,
                    "舱位: " + cabin,
                    "座位: " + seat
                ]
                delegate: Rectangle {
                    radius: 8
                    color: "#404040"
                    border.color: "#555555"
                    height: 34 * scale
                    width: Math.max(110 * scale, label.implicitWidth + 24 * scale)
                    Text {
                        id: label
                        anchors.centerIn: parent
                        text: modelData
                        color: "#dddddd"
                        font.pixelSize: 13 * scale
                    }
                }
            }
        }

        // 票面详细信息（和登机牌同一 Column）
        Rectangle {
            width: fitWidth(900, 1100)
            radius: 12
            color: "#262626"
            border.color: "#404040"
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                anchors.fill: parent
                anchors.margins: 20 * scale
                spacing: 10 * scale
                Text { text: "乘客: " + passengerName; color: "white"; font.pixelSize: 15 * scale }
                Text { text: "出发: " + depart; color: "white"; font.pixelSize: 14 * scale }
                Text { text: "到达: " + arrive; color: "white"; font.pixelSize: 14 * scale }
                Text { text: "起飞时间: " + departTime; color: "white"; font.pixelSize: 14 * scale }
                Text { text: "到达时间: " + arriveTime; color: "white"; font.pixelSize: 14 * scale }
                Text { text: "价格: ￥" + price.toFixed(2); color: "white"; font.pixelSize: 14 * scale }
            }
        }

        // 电子登机牌（左二维码 右信息）
        Rectangle {
            width: fitWidth(900, 1100)
            height: 180 * scale
            radius: 12
            color: "#202020"
            border.color: "#555555"
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20 * scale
                spacing: 20 * scale

                // 二维码（使用 FluQRCode）
                Item {
                    width: Math.round(qrBaseSize * scale)
                    height: Math.round(qrBaseSize * scale)
                    Layout.preferredWidth: width
                    Layout.preferredHeight: height
                    Rectangle { anchors.fill: parent; color: "#ffffff"; radius: 8; border.color: "#bbbbbb"; border.width: 1 }
                    FluQRCode {
                        anchors.centerIn: parent
                        color: qrColor
                        text: qrText
                        size: Math.round(qrBaseSize * scale)
                    }
                }

                // 登机牌信息
                ColumnLayout {
                    spacing: 8 * scale
                    Layout.fillWidth: true
                    Text { text: "电子登机牌"; color: "#ffffff"; font.pixelSize: 16 * scale; font.bold: true }
                    Text { text: "航班: " + flightNo; color: "#cccccc"; font.pixelSize: 13 * scale }
                    Text { text: "乘客: " + passengerName; color: "#cccccc"; font.pixelSize: 13 * scale }
                    Text { text: "座位: " + seat + "   舱位: " + cabin; color: "#cccccc"; font.pixelSize: 13 * scale }
                    Text { text: "请在登机口出示此电子登机牌"; color: "#aaaaaa"; font.pixelSize: 12 * scale }
                }
            }
        }
    }
}
