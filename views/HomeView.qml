import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluScrollablePage {
    launchMode: FluPageType.SingleTask
    animationEnabled: false
    header: Item{}

    property StackView stackView
    property var navView
    property var favoritesModel
    property var ordersModel
    property string userEmail
    property string userName

    ListModel {
        id: model_header
        ListElement {
            icon: "qrc:/qt/QT_Project/figures/github.png"
            title: qsTr("Uranus")
            desc: qsTr("A modern flight management system built with Qt and FluentUI.")
            url: "https://github.com/agsd-agsd/Flight-Management-System-FrontEnd"
            clicked: function(model){
                Qt.openUrlExternally(model.url)
            }
        }
        ListElement {
            icon: "qrc:/qt/QT_Project/figures/avatar-agsd.jpg"
            title: qsTr("Admin Login")
            desc: qsTr("Go to Admin Login")
            url: "qrc:/qt/QT_Project/views/AdminLogin.qml"
            clicked: function(model){
                if(stackView){
                    stackView.push(model.url, {stackView: stackView})
                }
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 320
        
        // 背景图
        Image {
            id: bg
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: "qrc:/qt/QT_Project/figures/bg.jpg"
            verticalAlignment: Qt.AlignTop
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.8; color: FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(1,1,1,0) }
                GradientStop { position: 1.0; color: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1) }
            }
        }

        FluText {
            text: "Uranus"
            font: FluTextStyle.TitleLarge
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 20
                leftMargin: 20
            }
        }

        Component {
            id: com_grallery
            Item {
                id: control
                width: 220
                height: 240
                FluShadow {
                    radius: 5
                    anchors.fill: item_content
                }
                FluClip {
                    id: item_content
                    radius: [5,5,5,5]
                    width: 200
                    height: 220
                    anchors.centerIn: parent
                    
                    FluAcrylic {
                        anchors.fill: parent
                        tintColor: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                        target: bg
                        tintOpacity: FluTheme.dark ? 0.8 : 0.9
                        blurRadius: 40
                        targetRect: Qt.rect(list.x - list.contentX + 10 + (control.width) * index, list.y + 10, width, height)
                    }
                    
                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        color: FluTheme.itemHoverColor
                        visible: item_mouse.containsMouse
                    }
                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        color: Qt.rgba(0,0,0,0.0)
                        visible: !item_mouse.containsMouse
                    }
                    
                    ColumnLayout {
                        Image {
                            Layout.topMargin: 20
                            Layout.leftMargin: 20
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            source: model.icon
                        }
                        
                        FluText {
                            text: model.title
                            font: FluTextStyle.Body
                            Layout.topMargin: 20
                            Layout.leftMargin: 20
                        }
                        FluText {
                            text: model.desc
                            Layout.topMargin: 5
                            Layout.preferredWidth: 160
                            Layout.leftMargin: 20
                            color: FluColors.Grey120
                            font.pixelSize: 12
                            font.family: FluTextStyle.family
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                    FluIcon {
                        iconSource: FluentIcons.OpenInNewWindow
                        iconSize: 15
                        anchors {
                            bottom: parent.bottom
                            right: parent.right
                            rightMargin: 10
                            bottomMargin: 10
                        }
                    }
                    MouseArea {
                        id: item_mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onWheel: (wheel) => {
                            if (wheel.angleDelta.y > 0) scrollbar_header.decrease()
                            else scrollbar_header.increase()
                        }
                        onClicked: {
                            model.clicked(model)
                        }
                    }
                }
            }
        }

        ListView {
            id: list
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            orientation: ListView.Horizontal
            height: 240
            model: model_header
            header: Item { height: 10; width: 10 }
            footer: Item { height: 10; width: 10 }
            ScrollBar.horizontal: FluScrollBar {
                id: scrollbar_header
            }
            clip: false
            delegate: com_grallery
        }
    }
    
    FluText {
        text: "System Features"
        font: FluTextStyle.Title
        Layout.topMargin: 20
        Layout.leftMargin: 20
    }
    
    Flow {
        Layout.fillWidth: true
        spacing: 20
        Layout.margins: 20
        
        Repeater {
            model: [
                { title: "Flight Search",   url: "qrc:/qt/QT_Project/views/FlightInfo.qml",      icon: FluentIcons.Airplane, desc: "Search for flights", navIndex: 1 },
                { title: "Ticket Booking",  url: "qrc:/qt/QT_Project/views/FlightInfo.qml",      icon: FluentIcons.Shop,   desc: "Book your tickets",  navIndex: 1 }, // 假设这也跳到查票
                { title: "Order Management",url: "qrc:/qt/QT_Project/views/OrdersView.qml",      icon: FluentIcons.Shop,     desc: "Manage your orders", navIndex: 2 },
                { title: "User Profile",    url: "qrc:/qt/QT_Project/views/ProfileView.qml",     icon: FluentIcons.Contact,  desc: "View your profile",  navIndex: 4 }, // 假设这是第4个
                { title: "Favorites",       url: "qrc:/qt/QT_Project/views/MyFavoritesPage.qml", icon: FluentIcons.Heart,    desc: "Your saved flights", navIndex: 3 }
            ]

            delegate: FluFrame {
                width: 300
                height: 100
                radius: 8
                
                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: item_mouse_feature.containsMouse ? FluTheme.itemHoverColor : FluTheme.itemNormalColor
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 20
                        color: FluTheme.primaryColor
                        FluIcon {
                            anchors.centerIn: parent
                            iconSource: modelData.icon
                            color: "white"
                        }
                    }
                    
                    ColumnLayout {
                        FluText {
                            text: modelData.title
                            font: FluTextStyle.BodyStrong
                        }
                        FluText {
                            text: modelData.desc
                            color: FluColors.Grey120
                            font: FluTextStyle.Caption
                        }
                    }
                }
                
                MouseArea {
                    id: item_mouse_feature
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // 1. 执行页面跳转
                        navView.push(modelData.url, {
                            "navView": navView,
                            "favoritesModel": favoritesModel,
                            "ordersModel": ordersModel,
                            "userEmail": userEmail,
                            "userName": userName
                        })
                        
                        // 2. 【关键修改】更新侧边栏选中项
                        // 注意：这里需要根据您 DashBoard.qml 中实际的 items 顺序来调整 navIndex
                        // 如果 navView 暴露了 setCurrentIndex 方法或属性，直接设置
                        if (modelData.navIndex !== undefined) {
                            // 尝试直接设置 currentIndex，这取决于 FluNavigationView 的具体实现
                            // 大多数 FluentUI 实现中，items 是一个 list，通过 index 控制选中
                            navView.setCurrentIndex(modelData.navIndex)
                        }
                    }
                }
            }
        }
    }
}
