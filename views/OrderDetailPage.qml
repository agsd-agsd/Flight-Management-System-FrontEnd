import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluPage {
    id: page
    title: "订单详情"

    property var navView
    property var stackView
    property string orderId: ""
    
    // 详情数据
    property string ticketId: "--"
    property string flightNo: "--"
    property string depart: "--"
    property string arrive: "--"
    property string departTime: "--"
    property string arriveTime: "--"
    property real price: 0.0
    property bool isRefund: false
    property string passengerName: "--"
    property string passengerPhone: "--"
    property string passengerIdCard: "--"

    // 辅助函数:转换时间
    function formatTimeStr(rawStr) {
        if (!rawStr) return "--:--"
        var date = new Date(rawStr)
        if (isNaN(date.getTime())) return rawStr
        return Qt.formatDateTime(date, "yyyy-MM-dd hh:mm")
    }

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(res, endpoint) {
            if (endpoint === "/GetOrderDetails") {
                if (res.success) {
                    ticketId = res.ticketid || "--"
                    flightNo = res.flightnumber || "--"
                    depart = res.departureairport || "--"
                    arrive = res.arrivalairport || "--"
                    departTime = formatTimeStr(res.departuretime)
                    arriveTime = formatTimeStr(res.arrivaltime)
                    price = res.price || 0
                    isRefund = res.isrefund || false
                    passengerName = res.passengername || "--"
                    passengerPhone = res.passengerphone || "--"
                    passengerIdCard = res.passengeridnumber || "--"
                } else {
                    showError("获取订单详情失败: " + (res.message || "未知错误"))
                }
            }
        }
        onRequestFailed: function(err) {
            showError("网络错误: " + err)
        }
    }

    Component.onCompleted: {
        if (orderId !== "") {
            networkHandler.request("/GetOrderDetails", NetworkHandler.POST, {
                email: GlobalSession.email,
                id: GlobalSession.userId,
                orderid: parseInt(orderId)
            })
        }
    }

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
            
            FluIconButton {
                iconSource: FluentIcons.ChromeBack
                onClicked: {
                    if (page.StackView.view) {
                        page.StackView.view.pop()
                        return
                    }
                    if (navView && typeof navView.pop === 'function') {
                        navView.pop()
                        return
                    }
                }
            }
            
            FluText {
                text: "订单详情"
                font.pixelSize: 20 * scale
                font.bold: true
                Layout.fillWidth: true
            }
        }
    }

    contentItem: Column {
        id: rootCol
        width: Math.min(parent.width, 1200)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 16
        spacing: 20 * scale

        // 订单号卡片
        FluRectangle {
            width: fitWidth(800, 1000)
            height: 64 * scale
            radius: [10,10,10,10]
            color: isRefund ? "#fff1f0" : (FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1))
            borderColor: isRefund ? "#ffa39e" : "#404040"
            borderWidth: 1
            anchors.horizontalCenter: parent.horizontalCenter
            FluText {
                anchors.centerIn: parent
                text: "订单号: " + orderId + (isRefund ? " (已退款)" : "")
                font.pixelSize: 22 * scale
                font.bold: true
                color: isRefund ? "#cf1322" : FluTheme.fontPrimaryColor
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

        // 标签区：航班号
        RowLayout {
            spacing: 12 * scale
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: [
                    "航班号: " + flightNo,
                    "票号: " + ticketId
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

        // 详细信息（乘客、价格等）
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
                
                FluText { text: "乘客姓名: " + passengerName; font.pixelSize: 15 * scale }
                FluText { text: "联系电话: " + passengerPhone; font.pixelSize: 15 * scale }
                FluText { text: "身份证号: " + passengerIdCard; font.pixelSize: 15 * scale }
                
                Rectangle { width: parent.width; height: 1; color: "#eee"; visible: !FluTheme.dark }
                
                FluText { text: "出发时间: " + departTime; font.pixelSize: 14 * scale }
                FluText { text: "到达时间: " + arriveTime; font.pixelSize: 14 * scale }
                FluText { text: "支付金额: ￥" + price.toFixed(2); font.pixelSize: 14 * scale; color: "#ff8819"; font.bold: true }
                FluText { text: "订单状态: " + (isRefund ? "已退款" : "已支付"); font.pixelSize: 14 * scale; color: isRefund ? "red" : "green" }
            }
        }
    }
}
