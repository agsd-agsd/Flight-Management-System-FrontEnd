import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluContentPage {
    id: root
    title: "我的收藏"

    property var navView
    property var favoritesModel // 接收全局收藏模型
    property var ordersModel // 兼容性属性
    property var stackView // 兼容性属性
    property string userEmail: "" // 兼容性属性
    property string userName: "" // 兼容性属性

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(res, endpoint){
            if(endpoint === "/GetStarTickets"){
                if(res.data && Array.isArray(res.data)){
                    favoritesModel.clear()
                    for(var i=0; i<res.data.length; i++){
                        var item = res.data[i]
                        favoritesModel.append({
                            ticketId: item.starid, // 注意：这里后端返回的是 starid 还是 ticketid 需要确认，假设是 starid 对应收藏记录，但详情页需要 ticketid
                            // 实际上后端返回的 data 包含 flightnumber 等信息，但可能没有原始 ticketid？
                            // 根据文档：starid, flightnumber, airline... 
                            // 如果没有 ticketid，我们可能无法跳转详情。
                            // 假设 starid 就是 ticketid 或者我们可以用 flightnumber 查
                            // 暂时用 starid 作为 ticketId
                            flightNo: item.flightnumber,
                            depart: item.departureairport,
                            arrive: item.arrivalairport,
                            departTime: item.departuretime,
                            arriveTime: item.arrivaltime,
                            price: item.price
                        })
                    }
                }
            }
        }
        onRequestFailed: function(err){
            showError("获取收藏失败: " + err)
        }
    }

    Component.onCompleted: {
        networkHandler.request("/GetStarTickets", NetworkHandler.POST, {
            email: GlobalSession.email,
            id: GlobalSession.userId,
            offset: 0,
            limit: 100
        })
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

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
        
        Item { Layout.fillHeight: true }
    }
}
