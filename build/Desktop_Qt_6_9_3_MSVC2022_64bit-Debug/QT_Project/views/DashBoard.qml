import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    property StackView stackView  // 接收传递的 stackView，用于返回

    // 示例主界面：飞行管理系统仪表盘
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // 标题栏（Fluent 风格）
        FluText {
            text: "欢迎，" + (networkHandler ? networkHandler.currentUser : "用户") + "！"  // 假设 NetworkHandler 有 currentUser
            font.pixelSize: 28
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 50
        }

        // 底部操作栏
        RowLayout {
            Layout.alignment: Qt.AlignBottomRight
            Layout.bottomMargin: 20

            FluFilledButton {
                text: "刷新航班"
                onClicked: {
                    if (networkHandler) networkHandler.fetchFlights()  // 假设有此方法
                }
            }

            FluTextButton {
                text: "注销"
                onClicked: {
                    if (networkHandler) networkHandler.logout()  // 清理会话
                    stackView.pop()  // 返回登录
                    // 可选：缩小窗口
                    window.width = window.width * 0.5
                    window.height = window.height * 0.5
                }
            }
        }
    }

    Component.onCompleted: {
        // 进入主界面：扩大窗口大小（从登录的小窗变大）
        window.width = Math.max(800, 0.8 * window.width)
        window.height = Math.max(600, 0.8 * window.height)
        window.requestActivate()  // 激活焦点
        console.log("Dashboard 加载成功")
    }
}
