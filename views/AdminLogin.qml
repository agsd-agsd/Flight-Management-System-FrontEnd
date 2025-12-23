import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0

Item {
    property StackView stackView

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        FluText {
            text: "管理员登录"
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        FluPasswordBox {
            id: passwordField
            placeholderText: "请输入管理员密钥"
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignHCenter
        }

        FluText {
            id: errorLabel
            color: "red"
            text: ""
            visible: false
            Layout.alignment: Qt.AlignHCenter
        }

        FluButton {
            text: "验证登录"
            Layout.preferredWidth: 120
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                var password = passwordField.text
                if (password === "") {
                    errorLabel.text = "请输入密钥"
                    errorLabel.visible = true
                    return
                }
                
                networkHandler.request("/AdminPasswordVerify", NetworkHandler.POST, {
                    password: password
                })
            }
        }
    }

    FluFilledButton {
        text: "返回"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20
        onClicked: {
            stackView.pop()
        }
    }

    NetworkHandler {
        id: networkHandler
        onRequestSuccess: function(res, endpoint){
            if(endpoint === "/AdminPasswordVerify"){
                showSuccess("管理员验证成功")
                stackView.push("AdminDashboard.qml", {
                    stackView: stackView
                })
            }
        }
        onRequestFailed: function(errMsg) {
             errorLabel.text = "验证失败: " + errMsg
             errorLabel.visible = true
        }
    }
}
