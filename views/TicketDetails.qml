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
    property bool isFavorite: false
    property var favoritesModel // 接收全局收藏模型
    property var ordersModel // 接收全局订单模型

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
            // 检查是否在收藏中
            if (favoritesModel) {
                for(var i=0; i<favoritesModel.count; i++) {
                    if(favoritesModel.get(i).ticketId === ticketId) {
                        isFavorite = true
                        break
                    }
                }
            }

            console.log("正在请求票务详情, ID:", ticketId)
            
            // 模拟数据，绕过后端
            
            if (ticketId === 90789) {
                flightNo = "MF4867"
                depart = "广州"
                arrive = "北京"
                departTime = "00:15"
                arriveTime = "02:20"
                price = 499.00
                return
            } else if (ticketId === 90790) {
                flightNo = "CA1234"
                depart = "上海"
                arrive = "深圳"
                departTime = "10:00"
                arriveTime = "12:30"
                price = 680.00
                return
            }
            

            var params = {
                "email": userEmail,
                "id": parseInt(userId),
                "ticketid": ticketId
            }
            // 假设接口路径为 /GetTicketDetails，请根据实际情况修改
            // detailHandler.request("/GetTicketDetails", NetworkHandler.POST, params)
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

    header: Item {
        height: 56
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12
            FluText {
                text: "机票详情"
                font.pixelSize: 18 * scale
                font.bold: true
                Layout.fillWidth: true
            }
            FluToggleButton{
                text: isFavorite ? "取消收藏" : "收藏"
                checked: isFavorite
                onClicked: {
                    isFavorite = !isFavorite
                    if (favoritesModel) {
                        if (isFavorite) {
                            // 添加到收藏
                            // 检查是否已存在
                            var exists = false
                            for(var i=0; i<favoritesModel.count; i++) {
                                if(favoritesModel.get(i).ticketId === ticketId) {
                                    exists = true
                                    break
                                }
                            }
                            if(!exists) {
                                favoritesModel.append({
                                    "ticketId": ticketId,
                                    "flightNo": flightNo,
                                    "depart": depart,
                                    "arrive": arrive,
                                    "departTime": departTime,
                                    "arriveTime": arriveTime,
                                    "price": price
                                })
                                console.log("已添加到收藏:", ticketId)
                            }
                        } else {
                            // 从收藏移除
                            for(var i=0; i<favoritesModel.count; i++) {
                                if(favoritesModel.get(i).ticketId === ticketId) {
                                    favoritesModel.remove(i)
                                    console.log("已从收藏移除:", ticketId)
                                    break
                                }
                            }
                        }
                    } else {
                        console.log("Error: favoritesModel is undefined")
                    }
                }
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
            FluFilledButton {
                text: "购买机票"
                onClicked: {
                    var props = {
                        "flightNo": flightNo,
                        "depart": depart,
                        "arrive": arrive,
                        "departTime": departTime,
                        "arriveTime": arriveTime,
                        "price": price,
                        "ticketId": ticketId,
                        "userEmail": userEmail,
                        "userId": userId,
                        "ordersModel": ordersModel // 传递给购买页
                    }
                    
                    if (page.StackView.view) {
                        page.StackView.view.push("qrc:/qt/QT_Project/views/BuyTicketPage.qml", props)
                    } else if (navView && typeof navView.push === 'function') {
                        navView.push("qrc:/qt/QT_Project/views/BuyTicketPage.qml", props)
                    }
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
        FluRectangle {
            width: fitWidth(800, 1000)
            height: 64 * scale
            radius: [10,10,10,10]
            color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
            borderColor: "#404040"
            borderWidth: 1
            anchors.horizontalCenter: parent.horizontalCenter
            FluText {
                anchors.centerIn: parent
                text: "票号: " + ticketId
                font.pixelSize: 22 * scale
                font.bold: true
            }
        }

        // 航线条（出发 → 到达）
        FluRectangle {
            width: fitWidth(900, 1100)
            height: 96 * scale
            radius: [12,12,12,12]
            color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
            borderColor: "#454545"
            borderWidth: 1
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16 * scale
                spacing: 20 * scale

                ColumnLayout {
                    spacing: 6 * scale
                    Layout.fillWidth: true
                    FluText { text: depart; font.pixelSize: 18 * scale; font.bold: true }
                    FluText { text: departTime; font.pixelSize: 14 * scale }
                }

                FluRectangle {
                    width: 60 * scale; height: 40 * scale
                    radius: [20 * scale, 20 * scale, 20 * scale, 20 * scale]
                    color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
                    Layout.preferredWidth: width
                    Layout.preferredHeight: height
                    FluText {
                        anchors.centerIn: parent
                        text: "→"
                        font.pixelSize: 22 * scale
                    }
                }

                ColumnLayout {
                    spacing: 6 * scale
                    Layout.fillWidth: true
                    FluText { text: arrive; font.pixelSize: 18 * scale; font.bold: true }
                    FluText { text: arriveTime; font.pixelSize: 14 * scale }
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
                delegate: FluRectangle {
                    radius: [8,8,8,8]
                    color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
                    borderColor: "#555555"
                    borderWidth: 1
                    height: 34 * scale
                    width: Math.max(110 * scale, label.implicitWidth + 24 * scale)
                    FluText {
                        id: label
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 13 * scale
                    }
                }
            }
        }

        // 票面详细信息（和登机牌同一 Column）
        FluRectangle {
            width: fitWidth(900, 1100)
            height: detailsCol.height + 40 * scale
            radius: [12,12,12,12]
            color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
            borderColor: "#404040"
            borderWidth: 1
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                id: detailsCol
                width: parent.width - 40 * scale
                anchors.centerIn: parent
                spacing: 10 * scale
                FluText { text: "乘客: " + passengerName; font.pixelSize: 15 * scale }
                FluText { text: "出发: " + depart; font.pixelSize: 14 * scale }
                FluText { text: "到达: " + arrive; font.pixelSize: 14 * scale }
                FluText { text: "起飞时间: " + departTime; font.pixelSize: 14 * scale }
                FluText { text: "到达时间: " + arriveTime; font.pixelSize: 14 * scale }
                FluText { text: "价格: ￥" + price.toFixed(2); font.pixelSize: 14 * scale }
            }
        }

        // 电子登机牌（左二维码 右信息）
        FluRectangle {
            width: fitWidth(900, 1100)
            height: 180 * scale
            radius: [12,12,12,12]
            color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
            borderColor: "#555555"
            borderWidth: 1
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
                    FluRectangle { 
                        anchors.fill: parent
                        color: "#ffffff"
                        radius: [8,8,8,8]
                        borderColor: "#bbbbbb"
                        borderWidth: 1
                        FluText {
                            anchors.centerIn: parent
                            text: "QR Code"
                            color: "#cccccc"
                            font.pixelSize: 12
                            z: -1
                        }
                    }
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
                    FluText { text: "电子登机牌"; font.pixelSize: 16 * scale; font.bold: true }
                    FluText { text: "航班: " + flightNo; font.pixelSize: 13 * scale }
                    FluText { text: "乘客: " + passengerName; font.pixelSize: 13 * scale }
                    FluText { text: "座位: " + seat + "   舱位: " + cabin; font.pixelSize: 13 * scale }
                    FluText { text: "请在登机口出示此电子登机牌"; font.pixelSize: 12 * scale }
                }
            }
        }
    }
}
