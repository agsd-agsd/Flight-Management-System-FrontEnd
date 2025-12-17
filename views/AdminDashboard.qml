import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

    Item {
    property StackView stackView  // 用于返回登录

    Component.onCompleted: {
        // 进入仪表盘：扩大主窗口大小并居中
        if (window) {
            // 长宽增加三分之一 (0.6 -> 0.8)
            var newW = Math.max(800, Screen.width * 0.8)
            var newH = Math.max(600, Screen.height * 0.8)

            window.width = newW
            window.height = newH

            // 居中显示
            window.x = (Screen.width - newW) / 2
            window.y = (Screen.height - newH) / 2

            window.requestActivate()
        }
        console.log("AdminDashboard 加载成功")
    }

    // 管理员端布局（FluNavigationView 实现侧边导航）
    FluNavigationView {
        id: adminNavView
        anchors.fill: parent
        pageMode: FluNavigationViewType.Stack
        displayMode: FluNavigationViewType.Auto
        visible: true


        Component.onCompleted: {
            // 默认跳转到首页
            navigateTo("qrc:/qt/QT_Project/views/ManageFlights.qml")
        }


        // 简化跳转函数
        function navigateTo(url) {
            // 传递 navView 和外层 stackView（用于以后需要返回到登录）
            // 同时传递全局收藏模型和订单模型
            adminNavView.push(url, {
                navView: adminNavView,
                stackView: stackView
            })
        }


        items:FluPaneItem {
                id: item_home
                title: qsTr("航班管理")
                icon: FluentIcons.Airplane
                url: "qrc:/qt/QT_Project/views/ManageFlights.qml"
                onTap: { adminNavView.navigateTo(url); }
            }



        // 辅助功能分组（底部次要功能）
        footerItems: FluPaneItemExpander {
            title: qsTr("辅助功能")
            iconVisible: false

            FluPaneItem {
                id: item_about
                title: qsTr("关于我们")
                icon: FluentIcons.Info
                url: "qrc:/qt/QT_Project/views/AboutView.qml"
                onTap: { adminNavView.navigateTo(url); }
            }

            FluPaneItem {
                id: item_logout
                title: qsTr("退出登录")
                icon: FluentIcons.SignOut
                onTap: {
                    if(stackView){
                        stackView.pop(null)
                    }
                }
            }

        }
    }
}

