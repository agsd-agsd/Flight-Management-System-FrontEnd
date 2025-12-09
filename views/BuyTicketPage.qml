import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluContentPage {
    id: page
    title: "购买机票"

    property string flightNo: ""
    property string depart: ""
    property string arrive: ""
    property string departTime: ""
    property string arriveTime: ""
    property real price: 0.0
    property int ticketId: 0
    property string userEmail: ""
    property string userId: ""
    property var ordersModel // 接收全局订单模型

    // 响应式尺寸因子
    property real w: width
    property real scale: Math.max(0.9, Math.min(1.4, w / 1000))
    function fitWidth(base, max) { return Math.min(w - 64, Math.min(max, base * scale)) }

    ScrollView {
        anchors.fill: parent
        contentWidth: parent.width
        
        ColumnLayout {
            width: Math.min(parent.width, 800)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            spacing: 16

            // 航班信息卡片
            FluRectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                radius: [8,8,8,8]
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
                borderWidth: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8

                    FluText {
                        text: "航班信息"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    RowLayout {
                        spacing: 10
                        FluText { text: "航班号:"; font.pixelSize: 16 }
                        FluText { text: flightNo; font.pixelSize: 16; font.bold: true }
                    }

                    RowLayout {
                        spacing: 10
                        FluText { text: depart + " → " + arrive; font.pixelSize: 16 }
                    }

                    RowLayout {
                        spacing: 10
                        FluText { text: departTime + " - " + arriveTime; font.pixelSize: 15 }
                    }
                }
            }

            // 乘客信息输入
            FluRectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                radius: [8,8,8,8]
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
                borderColor: "#404040"
                borderWidth: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    FluText {
                        text: "乘客信息"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true
                        FluText { 
                            text: "姓名:"
                            font.pixelSize: 16
                            Layout.preferredWidth: 70
                        }
                        FluTextBox {
                            id: passengerNameInput
                            placeholderText: "请输入乘客姓名"
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true
                        FluText { 
                            text: "身份证:"
                            font.pixelSize: 16
                            Layout.preferredWidth: 70
                        }
                        FluTextBox {
                            id: idCardInput
                            placeholderText: "请输入身份证号"
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true
                        FluText { 
                            text: "手机号:"
                            font.pixelSize: 16
                            Layout.preferredWidth: 70
                        }
                        FluTextBox {
                            id: phoneInput
                            placeholderText: "请输入手机号"
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // 价格信息
            FluRectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                radius: [8,8,8,8]
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
                borderColor: "#ff8819"
                borderWidth: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    FluText {
                        text: "总价:"
                        font.pixelSize: 18
                    }

                    FluText {
                        text: "¥" + price.toFixed(2)
                        font.pixelSize: 28
                        font.bold: true
                        Layout.fillWidth: true
                        color: "#ff8819"
                    }
                }
            }

            // 底部按钮区
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 20
                spacing: 15
                
                Item { Layout.fillWidth: true } // 占位符，将按钮推到右侧

                FluButton {
                    text: "取消"
                    onClicked: {
                        if (page.StackView.view) {
                            page.StackView.view.pop()
                        }
                    }
                }

                FluFilledButton {
                    text: "确认购买"
                    onClicked: {
                        console.log("确认购买机票")
                        
                        if (passengerNameInput.text === "" || idCardInput.text === "" || phoneInput.text === "") {
                            showError("请填写完整的乘客信息")
                            return
                        }

                        if (ordersModel) {
                            ordersModel.append({
                                "flightNo": flightNo,
                                "depart": depart,
                                "arrive": arrive,
                                "departTime": departTime,
                                "arriveTime": arriveTime,
                                "price": price,
                                "passengerName": passengerNameInput.text,
                                "idCard": idCardInput.text,
                                "phone": phoneInput.text,
                                "cabin": "经济舱",
                                "seatRow": "随机",
                                "seatCol": "",
                                "date": new Date().toLocaleDateString()
                            })
                            showSuccess("购票成功！")
                            
                            // 延迟返回，让用户看到成功提示
                            timer.start()
                        } else {
                            console.log("Error: ordersModel is undefined")
                        }
                    }
                }
            }
        }
    }
    
    Timer {
        id: timer
        interval: 1000
        onTriggered: {
            if (page.StackView.view) {
                page.StackView.view.pop()
            }
        }
    }
}
