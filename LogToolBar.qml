import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14

// ============================================================
// 顶部工具栏：毛玻璃背景 + 打开文件 / 级别过滤 / 搜索 / 匹配导航 / 清空
// 与外部只通过 property / signal 通信，不引用外部 id（组件封装）
// ============================================================
Rectangle {
    id: toolBar
    height: 52
    color: "transparent"        // 底色 = 模糊层 + 深色罩

    // ---------- 对外信号 ----------
    signal openRequested()
    signal levelChanged(string level)
    signal searchChanged(string keyword)
    signal jumpFirstRequested()
    signal prevRequested()
    signal nextRequested()
    signal clearRequested()

    // ---------- 对外属性 ----------
    property Item blurSource: null              // 毛玻璃抓取源（传列表卡片）
    property color overlayColor: "#001E293B"    // 深色罩色（alpha 控制顶栏通透度）
    readonly property alias searchText: searchField.text

    // ---------- 毛玻璃层：抓取横条内容做模糊 ----------
    FastBlur {
        anchors.fill: parent
        source: ShaderEffectSource {
            sourceItem: toolBar.blurSource
            sourceRect: Qt.rect(0, 0, toolBar.width, toolBar.height)
            width: toolBar.width
            height: toolBar.height
            visible: false
        }
        radius: 50
    }

    // ---------- 深色半透明罩：保证栏上控件对比度 ----------
    Rectangle {
        anchors.fill: parent
        color: toolBar.overlayColor
    }

    // ---------- 工具栏内容 ----------
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 10

        // 主按钮：打开文件
        Button {
            text: "打开文件"
            implicitHeight: 30
            background: Rectangle {
                implicitHeight: 30
                radius: 6
                color: parent.down ? "#1D4ED8"
                     : (parent.hovered ? "#3B82F6" : "#2563EB")
                Behavior on color { ColorAnimation { duration: 120 } }
            }
            contentItem: Text {
                text: "打开文件"
                color: "white"
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: toolBar.openRequested()
        }

        // 竖分隔线
        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 24
            color: "#475569"
        }

        // 级别过滤
        ComboBox {
            id: levelCombo
            implicitWidth: 96
            implicitHeight: 30
            font.pixelSize: 13
            model: ["ALL", "DEBUG", "INFO", "WARN", "ERROR"]
            onCurrentTextChanged: toolBar.levelChanged(currentText)

            background: Rectangle {
                radius: 6
                // 半透明磨砂：透出顶栏罩层与栏融合
                color: parent.hovered ? "#CCFFFFFF" : "#99FFFFFF"
                border.color: "#CCFFFFFF"
                Behavior on color { ColorAnimation { duration: 120 } }
            }

            // Basic 样式下拉的颜色直接读 palette（见 Controls.2/ComboBox.qml），
            // 改 palette 不依赖 popup 覆盖机制，稳定生效
            palette.window: "#EEFFFFFF"          // 下拉背景：磨砂白
            palette.mid: "#B4B2A9"               // 下拉边框：浅灰
            palette.text: "#1E293B"              // 下拉项文字
            palette.highlight: "#2563EB"         // 高亮底色
            palette.highlightedText: "#FFFFFF"   // 高亮文字

            // 弹出下拉：磨砂容器 + 定制项
            popup: Popup {
                y: levelCombo.height + 4
                width: levelCombo.width
                padding: 0
                implicitHeight: Math.min(dropList.contentHeight + 8, 300)

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: "#EEFFFFFF"
                    border.color: "#B4B2A9"
                    border.width: 1

                    ListView {
                        id: dropList
                        anchors.fill: parent
                        anchors.margins: 4
                        clip: true
                        model: levelCombo.popup.visible ? levelCombo.delegateModel : null
                        currentIndex: levelCombo.highlightedIndex

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                            width: 6
                        }

                        delegate: ItemDelegate {
                            width: dropList.width
                            height: 32
                            text: model.text
                            font.pixelSize: 13
                            highlighted: levelCombo.highlightedIndex === index
                            background: Rectangle {
                                radius: 6
                                color: parent.hovered || parent.highlighted
                                       ? "#1E293B33" : "transparent"
                            }
                            onClicked: {
                                levelCombo.currentIndex = index
                                levelCombo.popup.close()
                            }
                        }
                    }
                }
            }
        }

        // 搜索框
        TextField {
            id: searchField
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            placeholderText: "搜索关键词（命中行高亮，回车跳第一个）..."
            font.pixelSize: 13
            selectByMouse: true
            onTextChanged: toolBar.searchChanged(text)
            onAccepted: toolBar.jumpFirstRequested()
            background: Rectangle {
                radius: 6
                color: parent.hovered ? "#CCFFFFFF" : "#99FFFFFF"
                border.color: parent.activeFocus ? "#2563EB" : "#E2E8F0"
                border.width: parent.activeFocus ? 2 : 1
                Behavior on color { ColorAnimation { duration: 120 } }
            }
        }

        BarButton {
            text: "↑"
            implicitWidth: 32
            onClicked: toolBar.prevRequested()
        }
        BarButton {
            text: "↓"
            implicitWidth: 32
            onClicked: toolBar.nextRequested()
        }
        BarButton {
            text: "清空"
            implicitWidth: 56
            onClicked: toolBar.clearRequested()
        }
    }
}
