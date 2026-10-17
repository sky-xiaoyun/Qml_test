import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14

// ============================================================
// 日志列表：行渲染（徽章/合并计数/高亮）+ 选择（单击/Ctrl/拖动）+ 右键菜单 + 匹配导航
// 与外部只通过 property / signal 通信
// ============================================================
ListView {
    id: listView
    clip: true
    spacing: 0

    // ---------- 对外属性 ----------
    property string keyword: ""             // 搜索高亮关键词（由工具栏传入）
    property Item blurSource: null          // 右键菜单毛玻璃抓取源（传列表卡片）
    property Item scrollHost: null          // 滚动条 parent（传列表卡片）
    property int matchCursor: -1            // 当前匹配序号（-1 = 无）

    // ---------- 对外信号 ----------
    signal matchInfoChanged(string info)    // 状态栏"匹配 x/y"
    signal detailRequested(string rawLine)  // 双击 → 请求打开详情

    // ---------- 匹配导航 ----------
    function gotoFirstMatch() {
        matchCursor = -1
        gotoMatch(1)
    }
    function gotoPrev() { gotoMatch(-1) }
    function gotoNext() { gotoMatch(1) }

    function gotoMatch(delta) {
        if (!model || model.matchCount === 0) {
            matchCursor = -1
            matchInfoChanged("无匹配")
            return
        }
        if (matchCursor < 0)
            matchCursor = (delta > 0) ? 0 : model.matchCount - 1
        else
            matchCursor = (matchCursor + delta + model.matchCount) % model.matchCount

        const row = model.matchRowAt(matchCursor)
        currentIndex = row
        positionViewAtIndex(row, ListView.Center)
        matchInfoChanged("匹配 " + (matchCursor + 1) + " / " + model.matchCount)
    }

    // ---------- 首尾占位（滚动内容的一部分，滚走后半透明栏才能透出内容） ----------
    header: Item {
        width: listView.width
        height: 52
    }
    footer: Item {
        width: listView.width
        height: 30
    }

    // ---------- 滚动条：换 parent + anchors（跳过附加自动布局），缩进到栏间安全区 ----------
    ScrollBar.vertical: ScrollBar {
        parent: listView.scrollHost
        anchors.right: parent ? parent.right : undefined
        anchors.rightMargin: 2
        anchors.top: parent ? parent.top : undefined
        anchors.topMargin: 52
        anchors.bottom: parent ? parent.bottom : undefined
        anchors.bottomMargin: 30
        policy: ScrollBar.AsNeeded
        width: 14
        background: Rectangle { color: "transparent" }
        contentItem: Rectangle {
            radius: 7
            color: parent.hovered || parent.pressed ? "#94A3B8" : "#CBD5E1"
            Behavior on color { ColorAnimation { duration: 120 } }
        }
    }

    // ---------- 行 ----------
    delegate: Rectangle {
        width: listView.width
        height: 38

        readonly property bool isMatch: listView.keyword !== "" &&
                                        model.rawLine.indexOf(listView.keyword) >= 0

        color: {
            if (model.selected) return "#BFDBFE"                    // 选中（蓝-200）
            if (ListView.isCurrentItem) return "#FDE047"            // 当前匹配
            if (isMatch) return "#FEF08A"                           // 搜索命中
            if (rowMouse.containsMouse) return "#F8FAFC"            // 悬停
            if (model.level === "ERROR") return "#FEF2F2"
            if (model.level === "WARN") return "#FFFBEB"
            if (model.level === "DEBUG") return "#F8FAFC"
            return "#FFFFFF"
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 16
            spacing: 12

            Text {
                text: model.timestamp
                Layout.preferredWidth: 110
                font.family: "Consolas"
                font.pixelSize: 13
                color: "#334155"
                elide: Text.ElideRight
            }

            // 级别徽章
            Rectangle {
                Layout.preferredWidth: 56
                Layout.preferredHeight: 22
                radius: 4
                color: {
                    if (model.level === "ERROR") return "#FEE2E2"
                    if (model.level === "WARN") return "#FEF3C7"
                    if (model.level === "INFO") return "#DBEAFE"
                    return "#F1F5F9"
                }
                Text {
                    anchors.centerIn: parent
                    text: model.level
                    font.family: "Consolas"
                    font.pixelSize: 12
                    font.bold: true
                    color: {
                        if (model.level === "ERROR") return "#DC2626"
                        if (model.level === "WARN") return "#D97706"
                        if (model.level === "INFO") return "#2563EB"
                        return "#64748B"
                    }
                }
            }

            // 消息（连续重复合并时带 ×N）
            Text {
                text: model.repeat > 1 ? model.message + "  ×" + model.repeat
                                       : model.message
                Layout.fillWidth: true
                font.family: "Consolas"
                font.pixelSize: 14
                color: "#0F172A"
                elide: Text.ElideRight
            }
        }

        // 行底分隔线（最后一行不画）
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: "#E2E8F0"
            visible: index < (listView.model ? listView.model.count - 1 : -1)
        }

        MouseArea {
            id: rowMouse
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            property int dragAnchor: -1

            onPressed: {
                if (mouse.button !== Qt.LeftButton)
                    return
                listView.currentIndex = index
                if (mouse.modifiers & Qt.ControlModifier)
                    listView.model.toggleRow(index)         // Ctrl+单击：加/减选
                else
                    listView.model.selectRow(index, true)   // 单击：独占选中
                dragAnchor = index
            }

            // 右键：官方推荐在 onClicked 处理（press+release 完整后弹菜单）
            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    if (!model.selected)
                        listView.model.selectRow(index, true)
                    contextMenu.popup()
                }
            }

            onPositionChanged: {
                // 按住左键拖动：划过哪些行就选中到哪些行（连续多选）
                if (!pressed || dragAnchor < 0)
                    return
                const pt = mapToItem(listView, mouse.x, mouse.y)
                const target = listView.indexAt(pt.x, pt.y)
                if (target >= 0 && target !== dragAnchor)
                    listView.model.selectRange(dragAnchor, target)
            }

            onDoubleClicked: listView.detailRequested(model.rawLine)
        }
    }

    // ---------- 右键菜单（毛玻璃） ----------
    Menu {
        id: contextMenu

        background: Item {
            FastBlur {
                anchors.fill: parent
                source: ShaderEffectSource {
                    sourceItem: listView.blurSource
                    sourceRect: Qt.rect(contextMenu.x, contextMenu.y,
                                        contextMenu.width, contextMenu.height)
                    visible: false
                }
                radius: 24
            }
            Rectangle {
                anchors.fill: parent
                radius: 8
                color: "#CCFFFFFF"          // 80% 白罩，保证菜单文字可读
                border.color: "#B4B2A9"
            }
        }

        MenuItem {
            text: "复制选中行"
            enabled: listView.model && listView.model.selectionCount > 0
            onTriggered: listView.model.copySelectionToClipboard()
        }
        MenuItem {
            text: "复制全部"
            onTriggered: listView.model.copyAllToClipboard()
        }
    }
}
