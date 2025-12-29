import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluContentPage {
    id: aboutView
    title: qsTr("关于我们")

    property var navView

    Item {
        anchors.fill: parent
        anchors.margins: 20

        FluPivot {
            anchors.fill: parent
            currentIndex: 0

            FluPivotItem {
                title: qsTr("团队简介")
                contentItem: ColumnLayout {
                    anchors.fill: parent
                    spacing: 20

                    // 顶部图片区域
                    FluRectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 180
                        radius: [8,8,8,8]
                        color: FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(240/255,240/255,240/255,1)
                        clip: true

                        Image {
                            anchors.fill: parent
                            source: "qrc:/qt/QT_Project/figures/teamBackground.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    // 文本内容区域
                    Flickable {
                        clip: true
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        contentHeight: teamInfoCol.implicitHeight
                        ScrollBar.vertical: FluScrollBar {}

                        ColumnLayout {
                            id: teamInfoCol
                            width: parent.width
                            spacing: 15

                            FluText {
                                text: qsTr("610 Not Found")
                                font.pixelSize: 28
                                font.bold: true
                                Layout.alignment: Qt.AlignHCenter
                            }

                            FluText {
                                text: qsTr("610 Not Found致力于坑飞每一个用户")
                                font.pixelSize: 16
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                                lineHeight: 1.5
                            }

                            FluText {
                                text: qsTr("本项目名为Uranus,是一个基于Qt Quick和Fluent UI框架开发的全程github托管的项目，旨在为用户提供便捷的航班查询与预订服务。项目由四位核心成员组成，分别负责不同的模块开发与维护。")
                                font.pixelSize: 16
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                                lineHeight: 1.5
                            }
                        }
                    }
                }
            }

            // 成员模板函数
            component MemberPage: ColumnLayout {
                property string name
                property string role
                property string desc
                property color avatarColor
                property string avatarSource: "" // 新增头像路径属性

                anchors.fill: parent
                spacing: 20

                FluRectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                    width: 120
                    height: 120
                    radius: [60,60,60,60]
                    color: avatarSource ? "transparent" : avatarColor // 如果有图片则透明
                    
                    // 默认文字头像
                    FluText {
                        anchors.centerIn: parent
                        text: name.charAt(0).toUpperCase()
                        font.pixelSize: 48
                        color: "white"
                        font.bold: true
                        visible: !avatarSource // 如果有图片则隐藏
                    }

                    // 图片头像
                    FluImage {
                        anchors.fill: parent
                        source: avatarSource
                        visible: avatarSource !== ""
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                FluText {
                    text: name
                    font.pixelSize: 24
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }
                
                FluText {
                    text: role
                    font.pixelSize: 16
                    color: FluTheme.primaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                FluRectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#e0e0e0"
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10
                }

                Flickable {
                    clip: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: descText.implicitHeight
                    ScrollBar.vertical: FluScrollBar {}

                    FluText {
                        id: descText
                        width: parent.width
                        text: desc
                        font.pixelSize: 16
                        wrapMode: Text.WordWrap
                        lineHeight: 1.6
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            FluPivotItem {
                title: "Goutou"
                contentItem: MemberPage {
                    name: "Goutou"
                    role: "后端架构与部署工程师"
                    avatarColor: "#0078d4"
                    avatarSource: "qrc:/qt/QT_Project/figures/avatar-goutou.jpg"
                    desc: "负责后端代码编写，搭建后端HTTP服务框架，主导项目整体架构设计工作；服务器远程部署全流程工作；完成MySQL数据库搭建；后端服务Docker镜像化改造"
                }
            }

            FluPivotItem {
                title: "agsd"
                contentItem: MemberPage {
                    name: "agsd"
                    role: "前端用户端开发与接口联调工程师"
                    avatarColor: "#107c10"
                    avatarSource: "qrc:/qt/QT_Project/figures/avatar-agsd.jpg"
                    desc: "负责前端用户端较大部份功能代码编写，重点实现详情查看、收藏等用户高频操作功能；主导前端用户端主要UI设计与优化工作；承担前后端接口联调主要工作"
                }
            }

            FluPivotItem {
                title: "hjl"
                contentItem: MemberPage {
                    name: "hjl"
                    role: "前端管理员端开发与框架设计师"
                    avatarColor: "#d13438"
                    avatarSource: "qrc:/qt/QT_Project/figures/avatar-hjl.jpg"
                    desc: "负责前端管理员端核心功能代码编写，用户端重点实现查询等用户高频使用界面功能设计，主导前端框架选型与整体设计工作"
                }
            }

            FluPivotItem {
                title: "yhq"
                contentItem: MemberPage {
                    name: "yhq"
                    role: "项目协调与文档管理专员"
                    avatarColor: "#5c2d91"
                    avatarSource: "qrc:/qt/QT_Project/figures/avatar-yhq.jpg"
                    desc: "担任前后端工作计划协调员，统筹推进项目进度，协调前后端开发衔接；负责项目全流程文档编写工作；开展项目总结分析工作"
                }
            }
        }
    }
}
