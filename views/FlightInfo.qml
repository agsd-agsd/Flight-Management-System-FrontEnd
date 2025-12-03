import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    property StackView stackView
    property var navView
    property string url: ""    // 吸收导航附加的 url 避免报错

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 32

        FluText {
            text: "全部航班"
            font.pixelSize: 28
            Layout.alignment: Qt.AlignHCenter
        }

        FluButton {
            text: "测试详情页跳转"
            Layout.preferredWidth: 140
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                console.log("Push TicketDetails, navView=", navView)
                var payload = {
                    navView: navView,
                    stackView: stackView,
                    ticketId: 987654321,
                    flightNo: "CA1832",
                    depart: "广州白云 CAN",
                    arrive: "成都天府 TFU",
                    departTime: "2025-12-12 14:20",
                    arriveTime: "2025-12-12 16:55",
                    cabin: "公务舱",
                    seat: "3C",
                    passengerName: "李四",
                    price: 2360.50,
                    status: "已支付"
                }
                if (navView) {
                    navView.push("qrc:/qt/QT_Project/views/TicketDetails.qml", payload)
                } else {
                    console.log("navView 未传入")
                }
            }
        }
    }
}
