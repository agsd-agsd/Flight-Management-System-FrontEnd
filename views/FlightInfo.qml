import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0
import QT_Project

FluContentPage{
    id:rootPage
    title:"航班信息"
    property var navView
    property var favoritesModel // 接收全局收藏模型
    property var ordersModel // 接收全局订单模型
    property var cityList:["北京", "上海", "广州", "深圳", "成都", "香港","武汉"]
    property var flightData: []
    property string selectedDate:""

    property int currentOffset: 0
    property int pageSize: 20

    // 辅助函数:转换时间
    function formatTimeStr(rawStr) {
        if (!rawStr) return "--:--"
        var date = new Date(rawStr) // JS 会自动解析那个格式
        // "hh:mm" 表示 24小时制的时间，如 14:05
        // 如果想要日期加时间，可以用 "MM-dd hh:mm"
        return Qt.formatTime(date, "hh:mm")
    }




    FluInfoBar{
        id:infoBar
        root:rootPage
    }


    //搜索航班总数
    NetworkHandler{
        id:numHandler
        onRequestSuccess: function(res){
            console.log("【调试】查票数返回:", JSON.stringify(res))

            if(res.success){
                var totalTickets=res.ticketsnum
                console.log("查询到总票数：",totalTickets)

                if(totalTickets>0){
                    infoBar.showSuccess("查询成功")
                    fetchFlightList()
                }
                else{
                    flightData=[]
                    showInfo("该航线暂无航班")
                }
            }
            else{
                infoBar.showInfo("查询失败："+(res.message||"未知错误"))
            }
        }
        onRequestFailed: function(err){
            infoBar.showError("网络错误（查票数）："+err)
        }
    }
    //获取有的飞机票
    NetworkHandler{
        id: listHandler
        onRequestSuccess: function(res) {
            console.log("【调试】查列表返回:", JSON.stringify(res))

            if (res.success) {
                flightData = res.data || []
                console.log("列表加载完成")
            } else {
                infoBar.showError("加载列表失败: " + (res.message || "数据异常"))
            }
        }
        onRequestFailed: function(err) {
            infoBar.showError("网络错误(查列表): " + err)
        }
    }

    function startSearch(){
        // 模拟数据，绕过后端
        /*
        flightData = [
            {
                "ticketid": 90789,
                "flightnumber": "MF4867",
                "departureairport": "广州",
                "arrivalairport": "北京",
                "departuretime": "2025-12-08T00:15:00",
                "arrivaltime": "2025-12-08T02:20:00",
                "price": 499.00
            },
            {
                "ticketid": 90790,
                "flightnumber": "CA1234",
                "departureairport": "上海",
                "arrivalairport": "深圳",
                "departuretime": "2025-12-08T10:00:00",
                "arrivaltime": "2025-12-08T12:30:00",
                "price": 680.00
            }
        ]
        infoBar.showSuccess("已加载测试数据")
        return
        */


        var dep=comboDep.currentIndex===-1?"":comboDep.currentText
        var arr=comboArr.currentIndex===-1?"":comboArr.currentText
        if(dep===""||arr===""){
            infoBar.showWarning("请选择出发地和目的地")
            return
        }
        if(selectedDate===""){
            infoBar.showWarning("请选择出发日期")
            return
        }
        flightData=[]
        currentOffset=0
        var params={
            "email":GlobalSession.email,
            "id":parseInt(GlobalSession.userId),
            "departureairport": dep,
            "arrivalairport": arr,
            "time": selectedDate
        }
        console.log("【检查参数】正在发送:", JSON.stringify(params))
        numHandler.request("/GetTicketsNum", NetworkHandler.POST, params)

    }

    function fetchFlightList(){
        var dep = comboDep.currentText
        var arr = comboArr.currentText
        var params = {
            "email": GlobalSession.email,
            "id": parseInt(GlobalSession.userId),
            "sort": "starttime",
            "time": selectedDate,
            "departureairport": dep,
            "arrivalairport": arr,
            "offset": currentOffset,
            "limit": pageSize
        }
        console.log("【检查参数】正在发送:", JSON.stringify(params))
        listHandler.request("/GetTickets", NetworkHandler.POST, params)
    }

    //页面布局
    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
            z:999

            RowLayout{
                anchors.fill: parent
                anchors.margins: 16
                spacing: 0

                FluComboBox{
                    id:comboDep
                    model: cityList
                    editable: false
                    Layout.preferredWidth: 120
                    Layout.rightMargin: -40
                    Component.onCompleted: currentIndex=-1
                    displayText: currentIndex===-1?"出发地":currentText
                    onActivated: console.log(currentText)
                }

                FluIcon{
                    iconSource: FluentIcons.Forward
                    iconSize: 15;
                    Layout.rightMargin: 20
                }

                FluComboBox{
                    id:comboArr
                    model: cityList
                    editable: false
                    Layout.preferredWidth: 120
                    Layout.rightMargin: -20
                    Component.onCompleted: currentIndex=-1
                    displayText: currentIndex===-1?"目的地":currentText
                    onActivated: console.log(currentText)
                }

                FluCalendarPicker{
                    Layout.rightMargin: -20
                    text: selectedDate===""?"选择日期":selectedDate
                    onAccepted: {
                        var d=current
                        var y=d.getFullYear()
                        var m=d.getMonth()+1
                        var day=d.getDate()
                        selectedDate=y+"-"+(m<10?"0"+m:m)+"-"+(day<10?"0"+day:day)
                        //selectedData=Qt.formatDate(current,"yyyy-MM-dd")
                    }
                }

                FluFilledButton{
                    text:"筛选"
                    onClicked: {
                        startSearch()
                    }
                }
            }
        }

        //列出有的飞机票
        ListView{
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: flightData
            spacing: 10
            topMargin: 10

            delegate: Rectangle{
                width: ListView.view.width-40
                height: 100
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(248/255,248/255,248/255,1)
                radius: 8

                FluShadow { radius: 8; elevation: 2 }

                RowLayout{
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20

                    //显示航班号
                    FluText {
                        text: modelData.flightnumber
                        font.bold: true
                        font.pixelSize: 18
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Item { Layout.fillWidth: true }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4

                            // 显示大大的时间
                            FluText {
                                text: formatTimeStr(modelData.departuretime) + " ➝ " + formatTimeStr(modelData.arrivaltime)
                                font.pixelSize: 20
                                font.bold: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                        }
                    }

                    Item { Layout.fillWidth: true }

                    //显示价格
                    RowLayout{
                        Layout.alignment: Qt.AlignVCenter
                        spacing:15
                        FluText {
                            text: "¥" + modelData.price
                            color: "#ff4d4f"
                            font.bold: true
                            font.pixelSize: 20
                        }

                        FluFilledButton{
                            text:"查看详情"
                            Layout.preferredWidth: 70
                            Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignVCenter

                            onClicked: {
                                if(navView){
                                    // 假设 modelData 中包含 ticketid 字段
                                    // 如果后端返回的是 flightid，请将 modelData.ticketid 改为 modelData.flightid 或 modelData.id
                                    var tId = modelData.ticketid || modelData.id || 0
                                    
                                    navView.push("qrc:/qt/QT_Project/views/TicketDetails.qml",{
                                        "navView": navView,
                                        "userEmail": GlobalSession.email,
                                        "userId": GlobalSession.userId,
                                        "ticketId": tId,
                                        "favoritesModel": favoritesModel, // 传递给详情页
                                        "ordersModel": ordersModel, // 传递给详情页
                                    })
                                } else {
                                    console.log("Error: navView is undefined")
                                }
                            }
                        }
                    }
                }
            }
            FluText {
                visible: flightData.length === 0
                text: "暂无数据"
                anchors.centerIn: parent
                color: "#999"
            }
        }
    }
}
