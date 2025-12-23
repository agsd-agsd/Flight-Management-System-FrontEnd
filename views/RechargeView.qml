import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

FluScrollablePage {
    id: page
    title: "我的钱包"

    property var navView
    property string userEmail: "" // 从上一页传入
    property double balance: 0.00

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(res, endpoint){
            if(endpoint === "/AddCurrency"){
                showSuccess("充值成功！")
                // 充值成功后刷新余额
                networkHandler.request("/GetCurrency", NetworkHandler.POST, {
                    email: GlobalSession.email,
                    id: GlobalSession.userId
                })
            } else if (endpoint === "/GetCurrency") {
                console.log("【RechargeView】余额查询返回:", JSON.stringify(res))
                if(res.currency !== undefined) {
                    page.balance = parseFloat(res.currency)
                    // 同步到全局 Session
                    GlobalSession.balance = page.balance
                }
            }
        }
        onRequestFailed: function(err){
            showError("操作失败: " + err)
        }
    }

    Component.onCompleted: {
        // 进页面拉取最新余额
        networkHandler.request("/GetCurrency", NetworkHandler.POST, {
            email: GlobalSession.email,
            id: GlobalSession.userId
        })
    }

    ColumnLayout {
        Layout.topMargin: 20
        Layout.alignment: Qt.AlignHCenter
        width: Math.min(parent.width - 40, 500)
        spacing: 20

        // 余额卡片
        FluFrame {
            Layout.fillWidth: true
            height: 160
            padding: 20
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 10
                FluText {
                    text: "当前余额"
                    font: FluTextStyle.Body
                    color: FluColors.Grey100
                    Layout.alignment: Qt.AlignHCenter
                }
                FluText {
                    text: "¥ " + Math.floor(page.balance)
                    font: FluTextStyle.Display
                    color: FluTheme.primaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        FluText {
            text: "充值金额"
            font: FluTextStyle.Subtitle
            Layout.topMargin: 20
        }

        FluTextBox {
            id: amountInput
            placeholderText: "请输入充值金额"
            Layout.fillWidth: true
            validator: DoubleValidator { bottom: 0.01; top: 1000000.00; decimals: 2 }
        }

        // 快捷金额
        GridLayout {
            columns: 3
            rowSpacing: 10
            columnSpacing: 10
            Layout.fillWidth: true

            Repeater {
                model: [50, 100, 200, 500, 1000, 5000]
                FluButton {
                    text: "¥" + modelData
                    Layout.fillWidth: true
                    onClicked: amountInput.text = modelData
                }
            }
        }

        FluFilledButton {
            text: "立即充值"
            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.preferredHeight: 45
            onClicked: {
                var amt = parseInt(amountInput.text)
                if (isNaN(amt) || amt <= 0) {
                    showError("请输入有效的整数金额")
                    return
                }
                // 调用后端充值接口
                networkHandler.request("/AddCurrency", NetworkHandler.POST, {
                    email: GlobalSession.email,
                    id: GlobalSession.userId,
                    amount: amt
                })
            }
        }

        FluButton {
            text: "返回"
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.preferredHeight: 45
            onClicked: {
                if (page.StackView.view) {
                    page.StackView.view.pop()
                } else if (navView && typeof navView.pop === 'function') {
                    navView.pop()
                }
            }
        }
    }
}
