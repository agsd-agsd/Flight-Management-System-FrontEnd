import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluScrollablePage {
    launchMode: FluPageType.SingleTask
    animationEnabled: false
    header: Item{}

    ListModel {
        id: model_header
        ListElement {
            icon: "qrc:/qt/QT_Project/figures/avatar-agsd.jpg" // 替换为现有资源
            title: qsTr("Flight System")
            desc: qsTr("A modern flight management system built with Qt and FluentUI.")
            url: "https://github.com/zhuzichu520/FluentUI"
            clicked: function(model){
                Qt.openUrlExternally(model.url)
            }
        }
        ListElement {
            icon: "qrc:/qt/QT_Project/figures/avatar-agsd.jpg"
            title: qsTr("About Us")
            desc: qsTr("Learn more about our development team and mission.")
            url: "https://github.com/zhuzichu520/FluentUI"
            clicked: function(model){
                Qt.openUrlExternally(model.url)
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 320
        
        // 背景图占位
        Rectangle {
            id: bg
            anchors.fill: parent
            color: FluTheme.primaryColor
            // 渐变效果
            gradient: Gradient {
                GradientStop { position: 0.0; color: FluTheme.primaryColor }
                GradientStop { position: 1.0; color: FluTheme.dark ? "#000000" : "#ffffff" }
            }
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.8; color: FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(1,1,1,0) }
                GradientStop { position: 1.0; color: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1) }
            }
        }

        FluText {
            text: "Flight Management System"
            font: FluTextStyle.TitleLarge
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 20
                leftMargin: 20
            }
            color: "white"
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
                        // 图标占位
                        Rectangle {
                            Layout.topMargin: 20
                            Layout.leftMargin: 20
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            radius: 25
                            color: FluTheme.primaryColor
                            
                            FluText {
                                anchors.centerIn: parent
                                text: model.title.charAt(0)
                                color: "white"
                                font.pixelSize: 24
                            }
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

    // 移除 ItemsOriginal 相关代码，因为该对象未定义
    // 仅保留静态展示部分
    
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
            model: ["Flight Search", "Ticket Booking", "Order Management", "User Profile", "Favorites"]
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
                            iconSource: FluentIcons.Airplane
                            color: "white"
                        }
                    }
                    
                    ColumnLayout {
                        FluText {
                            text: modelData
                            font: FluTextStyle.BodyStrong
                        }
                        FluText {
                            text: "Feature description here"
                            color: FluColors.Grey120
                            font: FluTextStyle.Caption
                        }
                    }
                }
                
                MouseArea {
                    id: item_mouse_feature
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }
        }
    }
}
