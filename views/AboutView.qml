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

                        FluText {
                            anchors.centerIn: parent
                            text: "Team Photo Placeholder"
                            color: "#888888"
                            font.pixelSize: 20
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
                                text: qsTr("终端露台 (Terminal Terrace)")
                                font.pixelSize: 28
                                font.bold: true
                                Layout.alignment: Qt.AlignHCenter
                            }

                            FluText {
                                text: qsTr("Terminal Terrace Team (TTT) 由中山大学软件工程学院2023级的4名精英成员组成。我们致力于打造最流畅、最人性化的航班管理系统。")
                                font.pixelSize: 16
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                                lineHeight: 1.5
                            }

                            FluText {
                                text: qsTr("团队总部位于风景秀丽的珠海高新区，依托先进的软硬件设施，我们不断探索技术的边界。")
                                font.pixelSize: 16
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                                lineHeight: 1.5
                            }

                            FluText {
                                text: qsTr("本项目 '云途 AltAir' 采用现代化的 QML + C++ 技术栈构建，全程遵循开源精神，使用 GitHub 进行敏捷开发与版本管理。")
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
                title: "Jerrylingj"
                contentItem: MemberPage {
                    name: "Jerrylingj"
                    role: "总经理 / General Manager"
                    avatarColor: "#0078d4"
                    desc: "统筹全局，运筹帷幄。\n主要负责：用户端核心航班检索与筛选逻辑、主页架构设计、收藏与预定状态管理；以及管理员端的航班调度与用户信息管理系统。"
                }
            }

            FluPivotItem {
                title: "agsd"
                contentItem: MemberPage {
                    name: "agsd"
                    role: "技术总监 / CTO"
                    avatarColor: "#107c10"
                    avatarSource: "qrc:/qt/QT_Project/figures/avatar-agsd.jpg"
                    desc: "技术攻坚，架构基石。\n主要负责：底层网络请求库封装、AI智能客服系统集成、发现页实时旅游笔记流、以及高并发下的航班信息实时同步机制。"
                }
            }

            FluPivotItem {
                title: "math-zhuxy"
                contentItem: MemberPage {
                    name: "math-zhuxy"
                    role: "人事总监 / HRD"
                    avatarColor: "#d13438"
                    desc: "以人为本，体验至上。\n主要负责：用户中心全生命周期管理（注册、登录、鉴权）、个人信息与头像管理系统、以及充值系统的后端安全实现。"
                }
            }

            FluPivotItem {
                title: "YANGPuxyu"
                contentItem: MemberPage {
                    name: "YANGPuxyu"
                    role: "信息总监 / CIO"
                    avatarColor: "#5c2d91"
                    desc: "流程优化，交互创新。\n主要负责：订单全流程管理（预定、支付、改签、退票）的前后端闭环；充值中心的前端交互设计，以及本'关于我们'页面的精心雕琢。"
                }
            }
        }
    }
}
