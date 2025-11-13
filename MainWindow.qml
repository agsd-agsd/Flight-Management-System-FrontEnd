import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import AppComponents 1.0
import "./views"
FluWindow {
    id: window
    width: 0.4 * screen.width
    height: 0.4 * screen.height
    visible: true
    launchMode: FluWindowType.SingleTask
    fitsAppBarWindows: true

    effect: "gaussian-blur"
    tintOpacity: 0.8
    blurRadius: 60

    Component.onCompleted: {
        FluTheme.darkMode = FluThemeType.Dark
        FluTheme.accentColor = FluColors.Blue
        FluTheme.animationEnabled = true
        FluTheme.nativeText = true
        FluTheme.blurBehindWindowEnabled = true  // 全局启用模糊
    }

    appBar: FluAppBar {
        id: appBar
        height: 36
        showDark: true
        darkClickListener:(button)=>handleDarkChanged(button)
        closeClickListener: ()=>{ dialog_close.open() }
    }

    function handleDarkChanged(button){
        if(FluTools.isMacos() || !FluTheme.animationEnabled){
            changeDark()
        }else{
            loader_reveal.sourceComponent = com_reveal
            var target = window.containerItem()
            var pos = button.mapToItem(target,0,0)
            var mouseX = pos.x + button.width / 2
            var mouseY = pos.y + button.height / 2
            var radius = Math.max(distance(mouseX,mouseY,0,0),distance(mouseX,mouseY,target.width,0),distance(mouseX,mouseY,0,target.height),distance(mouseX,mouseY,target.width,target.height))
            var reveal = loader_reveal.item
            reveal.start(reveal.width*Screen.devicePixelRatio,reveal.height*Screen.devicePixelRatio,Qt.point(mouseX,mouseY),radius)
        }
    }

    Component{
        id: com_reveal
        CircularReveal{
            id: reveal
            target: window.containerItem()
            anchors.fill: parent
            darkToLight: FluTheme.dark
            onAnimationFinished:{
                //动画结束后释放资源
                loader_reveal.sourceComponent = undefined
            }
            onImageChanged: {
                changeDark()
            }
        }
    }

    function distance(x1,y1,x2,y2){
        return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    }

    function changeDark(){
        if(FluTheme.dark){
            FluTheme.darkMode = FluThemeType.Light
        }else{
            FluTheme.darkMode = FluThemeType.Dark
        }
    }

    FluLoader{
        id:loader_reveal
        anchors.fill: parent
    }
    FluContentDialog {
        id: dialog_close
        title: qsTr("退出")
        message: qsTr("确定要退出飞行管理系统吗？")
        negativeText: qsTr("取消")
        positiveText: qsTr("退出")
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        onPositiveClicked: Qt.quit()
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: Login { stackView: stackView }
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    }
}
