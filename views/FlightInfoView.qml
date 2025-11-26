import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    // 关键：接受 stackView 作为属性以支持页面跳转
    property StackView stackView

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 32

        FluText {
            text: "全部航班"
            font.pixelSize: 28
            Layout.alignment: Qt.AlignHCenter
        }

        // 你的航班列表可以放在这里，先省略用于测试
        // 真实情况下应该用 Repeater/ListView/FluTableView 等显示航班

        FluButton {
            text: "测试详情页跳转"
            Layout.preferredWidth: 120
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                // 跳转到 TicketDetail.qml，并传递一个测试票id
                if (stackView) {
                    stackView.push("TicketDetail.qml", {ticketId: 123, stackView: stackView})
                } else {
                    console.log("stackView is null, can't push!")
                }
            }
        }
    }
}
