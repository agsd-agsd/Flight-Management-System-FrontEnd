import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Item {
    property StackView stackView
    Rectangle {
        anchors.fill: parent
        color: "yellow"
    }

    Button {
        text: "回退至Login"
        onClicked: {
            stackView.pop()
        }
    }
}
