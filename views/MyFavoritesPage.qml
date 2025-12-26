import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluContentPage {
    id: root
    title: "我的收藏"

    property var navView
    property var ordersModel // 兼容性属性
    property var stackView // 兼容性属性
    property string userEmail: "" // 兼容性属性
    property string userName: "" // 兼容性属性

    ListModel {
                id: localFavoritesModel
            }
    property var favoritesModel: localFavoritesModel

    function formatTime(timeStr) {
            if (!timeStr) return "--:--"
            var parts = timeStr.split("T")
            if (parts.length > 1) {
                return parts[1].substring(0, 5)
            }
            return timeStr
    }


    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(res, endpoint){
            if(endpoint === "/GetStarTickets"){
                console.log("【MyFavoritesPage】收藏列表返回:", JSON.stringify(res))
                if(res.data){
                    favoritesModel.clear()
                    for(var i=0; i<res.data.length; i++){
                        var item = res.data[i]
                        // 后端已更新，现在返回 ticketid 了
                        var tId = item.ticketid || item.starid || 0
                        
                        favoritesModel.append({
                            ticketId: tId, 
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

    function refreshFavorites() {
        networkHandler.request("/GetStarTickets", NetworkHandler.POST, {
            email: GlobalSession.email,
            id: GlobalSession.userId,
            offset: 0,
            limit: 100
        })
    }

    Component.onCompleted: {
        refreshFavorites()
    }

    onVisibleChanged: {
        if(visible) {
            refreshFavorites()
        }
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
            
            // 移除 visible 绑定，或者确保 favoritesModel 初始化正确
            // visible: favoritesModel && favoritesModel.count > 0 
            
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
                        FluText { text: formatTime(model.departTime) + " - " + formatTime(model.arriveTime); font.pixelSize: 14; color: "#888888" }
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
