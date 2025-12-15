import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluContentPage {
    id: root
    title: "我的订单"

    property var navView
    property var stackView // 接收外层 StackView
    property var ordersModel // 接收全局订单模型
    property string userEmail: "" // 兼容性属性
    property string userName: "" // 兼容性属性
    property var favoritesModel // 兼容性属性
    property int pendingDeleteIndex: -1
    property string pendingOrderId: ""

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(res, endpoint){
            if(endpoint === "/GetOwnTickets"){
                if(res.data && Array.isArray(res.data)){
                    ordersModel.clear()
                    for(var i=0; i<res.data.length; i++){
                        var item = res.data[i]
                        // 转换后端数据格式到前端 Model
                        ordersModel.append({
                            orderId: item.orderid,
                            flightNo: item.flightnumber,
                            depart: item.departureairport,
                            arrive: item.arrivalairport,
                            departTime: item.departuretime,
                            arriveTime: item.arrivaltime,
                            price: item.price,
                            isRefund: item.isrefund,
                            // 暂时没有乘客信息，先用默认值或空
                            passengerName: GlobalSession.username, 
                            idCard: "",
                            cabin: "经济舱",
                            seatRow: "1",
                            seatCol: "A",
                            date: item.departuretime.split(" ")[0]
                        })
                    }
                }
            } else if (endpoint === "/RefundTicket") {
                showSuccess("退票成功")
                // 刷新列表
                refreshOrders()
                // 刷新余额
                networkHandler.request("/GetCurrency", NetworkHandler.POST, {
                    email: GlobalSession.email,
                    id: GlobalSession.userId
                })
            } else if (endpoint === "/GetCurrency") {
                if(res.currency !== undefined) {
                    GlobalSession.balance = parseFloat(res.currency)
                }
            }
        }
        onRequestFailed: function(err){
            showError("获取订单失败: " + err)
        }
    }

    function refreshOrders() {
        networkHandler.request("/GetOwnTickets", NetworkHandler.POST, {
            email: GlobalSession.email,
            userid: GlobalSession.userId,
            id: GlobalSession.userId, // [修复] 添加 id 参数，防止后端报错
            offset: 0,
            limit: 100
        })
    }

    Component.onCompleted: {
        refreshOrders()
    }

    FluContentDialog {
        id: refundDialog
        title: "确认退票"
        message: "您确定要退掉这张机票吗？此操作不可撤销。"
        negativeText: "取消"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        onNegativeClicked: {
            pendingDeleteIndex = -1
            pendingOrderId = ""
        }
        positiveText: "确定退票"
        onPositiveClicked: {
            if (pendingOrderId !== "") {
                networkHandler.request("/RefundTicket", NetworkHandler.POST, {
                    email: GlobalSession.email,
                    userid: GlobalSession.userId,
                    orderid: pendingOrderId
                })
                pendingDeleteIndex = -1
                pendingOrderId = ""
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // 订单列表
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: ordersModel
            spacing: 15
            
            // 空状态提示
            visible: ordersModel && ordersModel.count > 0
            
            delegate: FluRectangle {
                width: ListView.view.width
                height: 160
                radius: [8,8,8,8]
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
                borderWidth: 1
                borderColor: "#e0e0e0"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20
                    
                    // 左侧：航班信息
                    ColumnLayout {
                        Layout.preferredWidth: 200
                        spacing: 8
                        FluText { text: model.flightNo; font.pixelSize: 20; font.bold: true }
                        FluText { text: model.depart + " ➝ " + model.arrive; font.pixelSize: 16 }
                        FluText { text: model.departTime + " - " + model.arriveTime; font.pixelSize: 14; color: "#888888" }
                        FluText { text: model.date; font.pixelSize: 14; color: "#888888" }
                    }
                    
                    // 分割线
                    Rectangle {
                        Layout.fillHeight: true
                        width: 1
                        color: "#e0e0e0"
                    }

                    // 中间：乘客与座位信息
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        FluText { text: "乘客: " + model.passengerName; font.pixelSize: 16 }
                        FluText { text: "证件: " + model.idCard; font.pixelSize: 14; color: "#666666" }
                        FluText { text: "舱位: " + model.cabin; font.pixelSize: 14 }
                        FluText { text: "座位: " + model.seatRow + model.seatCol; font.pixelSize: 14; font.bold: true; color: FluTheme.primaryColor }
                    }

                    // 右侧：价格与状态
                    ColumnLayout {
                        Layout.alignment: Qt.AlignRight
                        spacing: 10
                        FluText { 
                            text: "已支付" 
                            color: "#52c41a"
                            font.bold: true
                            Layout.alignment: Qt.AlignRight
                        }
                        FluText { 
                            text: "¥" + model.price
                            font.pixelSize: 24
                            font.bold: true
                            color: "#ff8819"
                            Layout.alignment: Qt.AlignRight
                        }
                        FluFilledButton {
                            text: "退票"
                            Layout.alignment: Qt.AlignRight
                            onClicked: {
                                pendingDeleteIndex = index
                                pendingOrderId = model.orderId
                                refundDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }
}
