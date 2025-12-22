import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluContentPage {
    id: root
    title: "航班管理"

    // 修复属性声明
    property var navView
    property var stackView

    // 数据相关
    property var flightModel: ListModel {}
    property int currentPage: 0
    property int pageSize: 15 // 改小一点，适应一页显示
    property int totalCount: 0

    // 计算总页数
    property int totalPages: Math.ceil(totalCount / pageSize)

    property var airportList: ["北京", "广州", "上海", "成都", "武汉", "香港"]

    // --- 核心修改：使用百分比宽度，防止爆出屏幕 ---
    // 对应: ID, 航班号, 出发, 到达, 起飞时间, 到达时间, 价格, 操作
    // 总和必须等于 1.0
    property var colRatios: [0.06, 0.10, 0.08, 0.08, 0.22, 0.22, 0.10, 0.14]


    function formatTimeStr(str) {
        if(!str) return ""
        // 输入: 2025-11-20T08:30:00.000
        // 输出: 2025-11-20 08:30
        return str.replace("T", " ").substring(0, 16)
    }

    NetworkHandler {
            id: netHandler
            onRequestSuccess: function(res, endpoint){
                // 1. 处理数据列表返回
                if(endpoint === "/AdminSearchTickets"){
                    if(res.success){
                        flightModel.clear()
                        if(res.data){
                            for(var i=0; i<res.data.length; i++){
                                flightModel.append(res.data[i])
                            }
                        }

                    } else {
                        showError(res.message || "查询失败")
                    }
                }
                // 2.处理总数返回 (/AdminSearchTicketsCount)
                else if(endpoint === "/AdminSearchTicketsCount"){
                    if(res.success){
                        // 这才是真正的几千条数据总量
                        totalCount = res.count
                        console.log("获取到总条数: " + totalCount)
                    }
                }
                // 3. 处理添加/删除 (操作成功后，记得刷新列表和总数)
                else if(endpoint === "/AdminAddTicket" || endpoint === "/AdminDeleteFlight"){
                    if(res.success){
                        if(endpoint === "/AdminDeleteFlight" && res.refundcount > 0) {
                             showSuccess("删除成功\n退票人数: " + res.refundcount)
                        } else {
                             showSuccess("操作成功")
                        }
                        // 关闭对应弹窗
                        if(endpoint === "/AdminAddTicket") addDialog.close()
                        if(endpoint === "/AdminDeleteFlight") deleteDialog.close()

                        // 刷新列表
                        refreshList()
                    } else {
                        showError(res.message || "操作失败")
                    }
                }
            }
            onRequestFailed: function(err){ showError("网络错误: " + err) }
        }

        // 修改刷新函数：同时发两个请求
        function refreshList(){
            // 1. 请求当页数据
            netHandler.request("/AdminSearchTickets", NetworkHandler.POST, {
                departureairport: "all",
                arrivalairport: "all",
                startdate: "all",
                enddate: "all",
                ticketid: 0,
                flightnumber: searchBox.text.trim(),
                offset: currentPage * pageSize,
                limit: pageSize
            })

            // 2. 请求符合条件的总条数 (用于计算分页)
            // 注意：搜索条件(flightnumber)要和上面保持一致，否则页数会算错
            netHandler.request("/AdminSearchTicketsCount", NetworkHandler.POST, {
                departureairport: "all",
                arrivalairport: "all",
                startdate: "all",
                enddate: "all",
                ticketid: 0,
                flightnumber: searchBox.text.trim()
            })
        }

    Component.onCompleted: refreshList()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 5

        // --- 1. 顶部搜索栏 ---
        RowLayout {
            Layout.fillWidth: true
            Layout.bottomMargin: 10
            spacing: 10

            FluTextBox {
                id: searchBox
                placeholderText: "输入航班号 (如 CA1234)"
                Layout.preferredWidth: 240
                Keys.onEnterPressed: { currentPage=0; refreshList() }
                Keys.onReturnPressed: { currentPage=0; refreshList() }
            }

            FluButton {
                text: "搜索"
                //icon: FluentIcons.Search
                onClicked: { currentPage=0; refreshList() }
            }

            Item { Layout.fillWidth: true }

            FluFilledButton {
                text: "添加新航班"
                //icon: FluentIcons.Add
                onClicked: addDialog.open()
            }
        }

        // --- 2. 表头 (使用 colRatios 自适应宽度) ---
        Rectangle {
            Layout.fillWidth: true
            height: 45
            color: FluTheme.dark ? "#252525" : "#f0f0f0"
            radius: 4

            Row {
                anchors.fill: parent
                // 注意：这里用 Row 而不是 RowLayout，方便手动控制 Item 的 width

                // 辅助函数：生成表头项
                Repeater {
                    model: ["ID", "航班号", "出发地", "目的地", "起飞时间", "到达时间", "价格", "操作"]
                    Item {
                        // 宽度 = 父容器总宽 * 对应比例
                        width: parent.width * colRatios[index]
                        height: parent.height
                        FluText {
                            text: modelData
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }
                }
            }
        }

        // --- 3. 航班列表 ---
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: flightModel
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
                // 宽度跟随 ListView，保证自适应
                width: ListView.view.width
                height: 50
                color: {
                        if(index % 2 === 0) return "transparent"
                        return FluTheme.dark ? "#2d2d2d" : "#f9f9f9"
                    }

                Row {
                    anchors.fill: parent

                    // ID
                    Item { width: parent.width * colRatios[0]; height: parent.height; FluText { text: model.ticketid; anchors.centerIn: parent } }
                    // 航班号
                    Item { width: parent.width * colRatios[1]; height: parent.height; FluText { text: model.flightnumber; anchors.centerIn: parent } }
                    // 出发地
                    Item { width: parent.width * colRatios[2]; height: parent.height; FluText { text: model.departureairport; anchors.centerIn: parent } }
                    // 目的地
                    Item { width: parent.width * colRatios[3]; height: parent.height; FluText { text: model.arrivalairport; anchors.centerIn: parent } }

                    // 起飞时间 (格式化 + 省略号)
                    Item {
                        width: parent.width * colRatios[4]; height: parent.height;
                        FluText {
                            text: formatTimeStr(model.departuretime) // 调用格式化函数
                            anchors.centerIn: parent
                            width: parent.width - 10
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                            font.pixelSize: 12 // 时间字稍微小一点点
                        }
                    }
                    // 到达时间
                    Item {
                        width: parent.width * colRatios[5]; height: parent.height;
                        FluText {
                            text: formatTimeStr(model.arrivaltime)
                            anchors.centerIn: parent
                            width: parent.width - 10
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                            font.pixelSize: 12
                        }
                    }

                    // 价格
                    Item { width: parent.width * colRatios[6]; height: parent.height; FluText { text: "¥" + model.price; anchors.centerIn: parent; color: "#ff9900" } }

                    // 操作
                    Item {
                        width: parent.width * colRatios[7]
                        height: parent.height
                        FluIconButton {
                            anchors.centerIn: parent
                            iconSource: FluentIcons.Delete
                            iconSize: 14
                            color: "#ff4d4f"
                            text: "删除"
                            onClicked: {
                                deleteDialog.pendingId = model.ticketid
                                deleteDialog.open()
                            }
                        }
                    }
                }

                Rectangle { width: parent.width; height: 1; color: "#eee"; anchors.bottom: parent.bottom }
            }
        }

        // --- 4. 底部翻页栏 (新增) ---
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: "transparent"

            RowLayout {
                anchors.centerIn: parent
                spacing: 20

                FluButton {
                    text: "上一页"
                    enabled: currentPage > 0
                    onClicked: { currentPage--; refreshList() }
                }

                FluText {
                    text: "第 " + (currentPage + 1) + " / " + (totalPages || 1) + " 页"
                    color: "#666"
                }

                FluButton {
                    text: "下一页"
                    // 如果当前页小于 (总页数-1)，则可以翻页
                    enabled: currentPage < (totalPages - 1)
                    onClicked: { currentPage++; refreshList() }
                }
            }
        }
    }

    // --- 5. 添加航班弹窗 (修复作用域问题) ---
    FluContentDialog {
        id: addDialog
        title: "添加新航班"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        negativeText: "取消"
        positiveText: "提交"

        // === 1. 定义中间变量用来存数据 ===
        property string tempFlightNo: ""
        property string tempPrice: ""
        property string tempDepTime: ""
        property string tempArrTime: ""
        property int tempDepIndex: -1
        property int tempArrIndex: -1

        // === 2. 打开时，清空这些变量 ===
        onOpened: {
            tempFlightNo = ""
            tempPrice = ""
            tempDepTime = ""
            tempArrTime = ""
            tempDepIndex = -1
            tempArrIndex = -1
        }

        // === 3. 界面绑定到变量 ===
        contentDelegate: Component {
            ColumnLayout {
                spacing: 15
                width: 350

                FluText { text: "航班编号 (如 CA1234)"; font.pixelSize: 12; color: FluTheme.dark ? "#ccc" : "#666" }

                FluTextBox {
                    Layout.fillWidth: true
                    placeholderText: "两位字母四位数字"
                    // 双向绑定：显示变量的值，输入时更新变量
                    text: addDialog.tempFlightNo
                    onTextChanged: addDialog.tempFlightNo = text
                }

                FluText { text: "路线选择"; font.pixelSize: 12; color: FluTheme.dark ? "#ccc" : "#666" }
                RowLayout {
                    FluComboBox {
                        Layout.fillWidth: true
                        model: airportList
                        // 绑定索引
                        currentIndex: addDialog.tempDepIndex
                        onActivated: addDialog.tempDepIndex = index
                        displayText: currentIndex === -1 ? "起飞机场" : currentText
                    }
                    FluText { text: "→"; color: FluTheme.dark ? "#fff" : "#000" }
                    FluComboBox {
                        Layout.fillWidth: true
                        model: airportList
                        currentIndex: addDialog.tempArrIndex
                        onActivated: addDialog.tempArrIndex = index
                        displayText: currentIndex === -1 ? "到达机场" : currentText
                    }
                }

                FluText { text: "时间 (格式: 年-月-日-时-分)"; font.pixelSize: 12; color: FluTheme.dark ? "#ccc" : "#666" }
                FluTextBox {
                    Layout.fillWidth: true
                    placeholderText: "起飞: 2025-12-20-23-50"
                    text: addDialog.tempDepTime
                    onTextChanged: addDialog.tempDepTime = text
                }
                FluTextBox {
                    Layout.fillWidth: true
                    placeholderText: "到达: 2025-12-21-02-30"
                    text: addDialog.tempArrTime
                    onTextChanged: addDialog.tempArrTime = text
                }

                FluText { text: "票价"; font.pixelSize: 12; color: FluTheme.dark ? "#ccc" : "#666" }
                FluTextBox {
                    Layout.fillWidth: true
                    placeholderText: "请输入正整数"
                    validator: IntValidator { bottom: 1; top: 999999 }
                    text: addDialog.tempPrice
                    onTextChanged: addDialog.tempPrice = text
                }
            }
        }

        // === 4. 提交时，读取变量 ===
        onPositiveClicked: {
            var timeReg = /^\d{4}-\d{2}-\d{2}-\d{2}-\d{2}$/;

            // 使用 temp 变量进行校验
            if(!timeReg.test(tempDepTime) || !timeReg.test(tempArrTime)){
                showError("时间格式错误！必须为：YYYY-MM-DD-HH-mm")
                return
            }
            if(tempDepIndex === -1 || tempArrIndex === -1){
                showError("请选择机场")
                return
            }
            // 从数组里取城市名
            var depCity = airportList[tempDepIndex]
            var arrCity = airportList[tempArrIndex]

            if(depCity === arrCity){
                showError("起飞和到达机场不能相同")
                return
            }

            var params = {
                flightnumber: tempFlightNo,
                departureairport: depCity,
                arrivalairport: arrCity,
                departuretime: tempDepTime,
                arrivaltime: tempArrTime,
                price: parseInt(tempPrice)
            }
            netHandler.request("/AdminAddTicket", NetworkHandler.POST, params)
        }
    }

    FluContentDialog {
        id: deleteDialog
        property int pendingId: -1
        title: "确认删除"
        message: "确定删除该航班吗？"
        negativeText: "取消"
        positiveText: "确定删除"
        onPositiveClicked: {
            netHandler.request("/AdminDeleteFlight", NetworkHandler.POST, { flightid: pendingId })
        }
    }
}
