import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import NetworkHandler 1.0
import QT_Project 1.0

FluScrollablePage {
    title: "Manage Flights"
    
    ColumnLayout {
        anchors.fill: parent
        FluText {
            text: "Manage Flights Page"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
