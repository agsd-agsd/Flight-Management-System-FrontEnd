import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluContentPage {
    id: root
    title: "我的收藏"

    property var navView
    property var favoritesModel // 接收全局收藏模型

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        FluText {
            text: "我的收藏列表"
            font.pixelSize: 24
            font.bold: true
        }

        // 占位内容，后续可以替换为实际的收藏列表
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: favoritesModel
            spacing: 10
            
            // 空状态提示
            visible: favoritesModel && favoritesModel.count > 0
            
            delegate: FluRectangle {
                width: ListView.view.width
                height: 100
                radius: [8,8,8,8]
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
                borderWidth: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 20
                    
                    ColumnLayout {
                        spacing: 5
                        FluText { text: model.flightNo; font.pixelSize: 18; font.bold: true }
                        FluText { text: "票号: " + model.ticketId; font.pixelSize: 12; color: "#888888" }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    ColumnLayout {
                        spacing: 5
                        FluText { text: model.depart + " → " + model.arrive; font.pixelSize: 16 }
                        FluText { text: model.departTime + " - " + model.arriveTime; font.pixelSize: 14; color: "#888888" }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    FluText { text: "¥" + model.price; font.pixelSize: 18; font.bold: true; color: "#ff8819" }
                    
                    FluButton {
                        text: "查看"
                        onClicked: {
                            if(navView) {
                                navView.push("qrc:/qt/QT_Project/views/TicketDetails.qml", {
                                    "navView": navView,
                                    "ticketId": model.ticketId,
                                    "favoritesModel": favoritesModel
                                })
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
            visible: !favoritesModel || favoritesModel.count === 0
            
            FluText {
                anchors.centerIn: parent
                text: "暂无收藏的航班"
                color: "#888888"
                font.pixelSize: 16
            }
        }
        
        Item { Layout.fillHeight: true }
    }
}
