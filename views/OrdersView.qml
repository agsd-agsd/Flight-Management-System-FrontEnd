import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluContentPage {
    id: root
    title: "我的订单"

    property var navView
    property var ordersModel // 接收全局订单模型

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        FluText {
            text: "我的订单列表"
            font.pixelSize: 24
            font.bold: true
        }

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
                        FluButton {
                            text: "退票"
                            Layout.alignment: Qt.AlignRight
                            onClicked: {
                                // 简单的退票逻辑：直接从模型移除
                                ordersModel.remove(index)
                            }
                        }
                    }
                }
            }
        }

        FluRectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            radius: [8,8,8,8]
            color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
            borderWidth: 1
            visible: !ordersModel || ordersModel.count === 0
            
            FluText {
                anchors.centerIn: parent
                text: "暂无订单记录"
                color: "#888888"
                font.pixelSize: 16
            }
        }
    }
}
