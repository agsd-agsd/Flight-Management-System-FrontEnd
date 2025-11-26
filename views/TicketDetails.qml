import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    property int ticketId: 0
    property StackView stackView

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        FluText {
            text: "票详情测试页"
            font.pixelSize: 26
            Layout.alignment: Qt.AlignHCenter
        }
        FluText {
            text: "当前票ID: " + ticketId
            font.pixelSize: 18
            Layout.alignment: Qt.AlignHCenter
        }

        FluButton {
            text: "返回"
            Layout.preferredWidth: 80
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                if (stackView) stackView.pop()
            }
        }
    }
}
