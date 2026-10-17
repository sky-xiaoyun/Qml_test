import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14
import "."

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
    property color overlayColor: Theme.bar      // 深色罩色（alpha 控制顶栏通透度；#00 全透明）
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
                color: parent.down ? Theme.accentDown
                     : (parent.hovered ? Theme.accentHover : Theme.accent)
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
            color: Theme.dividerDark
        }

        // 级别过滤
        ComboBox {
            id: levelCombo
            implicitWidth: 96
            implicitHeight: 30
            font.pixelSize: 13
            model: ["ALL", "DEBUG", "INFO", "WARN", "ERROR"]
            onCurrentTextChanged: toolBar.levelChanged(currentText)

            // ★ 下拉项样式：必须覆写 ComboBox 自己的 delegate 属性。
            // popup 里 ListView 的 model 是 delegateModel（自带 delegate），那里写的 delegate 不生效。
            // Basic 默认 delegate 的悬停底 = palette.midlight（浅灰）+ highlightedText（白字），
            // 这正是"浅底浅字"看不清的根源。
            delegate: ItemDelegate {
                id: comboItem
                width: levelCombo.width
                text: modelData
                font.pixelSize: 13
                highlighted: levelCombo.highlightedIndex === index

                contentItem: Text {
                    text: comboItem.text
                    color: (comboItem.hovered || comboItem.highlighted) ? "white" : Theme.text
                    font: comboItem.font
                    elide: Text.ElideRight
                    leftPadding: 8
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: 6
                    color: (comboItem.hovered || comboItem.highlighted) ? Theme.accent : "transparent"
                }

                onClicked: {
                    levelCombo.currentIndex = index
                    levelCombo.popup.close()
                }
            }

            background: Rectangle {
                radius: 6
                // 半透明磨砂：透出顶栏罩层与栏融合
                color: parent.hovered ? Theme.glassHover : Theme.glassLight
                border.color: Theme.glassHover
                Behavior on color { ColorAnimation { duration: 120 } }
            }

            // Basic 样式下拉的颜色直接读 palette（见 Controls.2/ComboBox.qml），
            // 改 palette 不依赖 popup 覆盖机制，稳定生效
            palette.window: Theme.glassPanel       // 下拉背景（兜底）
            palette.mid: Theme.border              // 下拉边框（兜底）
            palette.text: Theme.text               // 下拉项文字
            palette.highlight: Theme.accent        // 高亮底色
            palette.highlightedText: "white"       // 高亮文字

            // 弹出下拉：真毛玻璃（抓后面列表内容做模糊）+ 磨砂白罩（无边框）
            popup: Popup {
                y: levelCombo.height + 4
                width: levelCombo.width
                padding: 0
                implicitHeight: Math.min(dropList.contentHeight + 8, 300)

                // 毛玻璃层：抓下拉覆盖区域的列表内容
                FastBlur {
                    anchors.fill: parent
                    source: ShaderEffectSource {
                        sourceItem: toolBar.blurSource
                        sourceRect: Qt.rect(levelCombo.popup.x, levelCombo.popup.y,
                                            levelCombo.popup.width, levelCombo.popup.height)
                        visible: false
                    }
                    radius: 24
                }

                // 磨砂白罩（无边框，方角——Qt 5.14 的 clip 不支持圆角裁剪）
                Rectangle {
                    anchors.fill: parent
                    color: Theme.glassPanel
                }

                // 选项列表（最上层）
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

                    // delegate 不写在这里！model 是 ComboBox 的 delegateModel（自带 delegate），
                    // ListView 的 delegate 属性会被忽略——正确的 delegate 写在 ComboBox 上（上方）
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
                color: parent.hovered ? Theme.glassHover : Theme.glassLight
                border.color: parent.activeFocus ? Theme.accent : Theme.border
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
