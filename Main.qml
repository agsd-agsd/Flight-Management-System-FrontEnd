import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0  // FluentUI 核心导入

FluWindow {
    id: window
    width: 0.4*screen.width
    height: 0.4*screen.height
    visible: true
    title:qsTr("StackView")

    StackView{
        id: stackView
        anchors.fill:parent
        //背景视图
        Rectangle {
            anchors.fill: parent
            color: "black"  // #000000
        }

        initialItem: Login {
            stackView: stackView
        }

        // 过渡动画：淡入淡出（简单优雅）
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300  // 毫秒，调慢点如 500 更柔和
                easing.type: Easing.InOutQuad  // 平滑曲线
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    }
}
