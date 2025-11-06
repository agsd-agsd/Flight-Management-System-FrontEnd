import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Item {
    property StackView stackView
    Rectangle {
        anchors.fill: parent
        color: "red"
    }
    Button {
        anchors.right: parent.right
        text: "进入视图2"
        onClicked: {
            stackView.push("Register.qml",{stackView:stackView})
        }
    }
}
