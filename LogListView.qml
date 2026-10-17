import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import "."

// ============================================================
// 日志列表：行渲染（徽章/合并计数/高亮）+ 单选 + 匹配导航
// ============================================================
ListView {
    id: listView
    clip: true
    spacing: 0

    // ---------- 对外属性 ----------
    property string keyword: ""             // 搜索高亮关键词（由工具栏传入）
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
            color: parent.hovered || parent.pressed ? Theme.scrollHover : Theme.scroll
            Behavior on color { ColorAnimation { duration: 120 } }
        }
    }

    // ---------- 行 ----------
    delegate: Rectangle {
        width: listView.width
        height: 38

        readonly property bool isMatch: listView.keyword !== "" &&
                                        model.rawLine.indexOf(listView.keyword) >= 0

        // 优先级：选中 > 当前匹配 > 搜索命中 > 悬停 > 级别底色
        color: {
            if (model.selected) return Theme.selected
            if (ListView.isCurrentItem) return Theme.current
            if (isMatch) return Theme.match
            if (rowMouse.containsMouse) return Theme.hoverRow
            if (model.level === "ERROR") return Theme.errorBg
            if (model.level === "WARN") return Theme.warnBg
            if (model.level === "DEBUG") return Theme.debugBg
            return Theme.surface
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
                color: Theme.textSub
                elide: Text.ElideRight
            }

            // 级别徽章
            Rectangle {
                Layout.preferredWidth: 56
                Layout.preferredHeight: 22
                radius: 4
                color: {
                    if (model.level === "ERROR") return Theme.errorBadgeBg
                    if (model.level === "WARN") return Theme.warnBadgeBg
                    if (model.level === "INFO") return Theme.infoBadgeBg
                    return Theme.debugBadgeBg
                }
                Text {
                    anchors.centerIn: parent
                    text: model.level
                    font.family: "Consolas"
                    font.pixelSize: 12
                    font.bold: true
                    color: {
                        if (model.level === "ERROR") return Theme.errorText
                        if (model.level === "WARN") return Theme.warnText
                        if (model.level === "INFO") return Theme.infoText
                        return Theme.debugText
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
                color: Theme.text
                elide: Text.ElideRight
            }
        }

        // 行底分隔线（最后一行不画）
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: Theme.border
            visible: index < (listView.model ? listView.model.count - 1 : -1)
        }

        MouseArea {
            id: rowMouse
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                listView.currentIndex = index
                listView.model.selectRow(index)      // 单击：单选
            }

            onDoubleClicked: listView.detailRequested(model.rawLine)
        }
    }
}
