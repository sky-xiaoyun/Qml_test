import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtQuick.Dialogs 1.3
import com.demo 1.0

// ============================================================
// 日志查看器 —— 主窗口
// 结构：列表卡片（底层） + 顶栏/底栏（毛玻璃浮层） + 弹窗
// ============================================================
ApplicationWindow {
    id: window
    visible: true
    width: 1000
    height: 700
    minimumWidth: 800
    minimumHeight: 500
    title: "日志查看器"
    font.family: "Microsoft YaHei"

    LogModel { id: logModel }

    // ==================== 底层：列表卡片（延伸到顶栏下，供毛玻璃透出） ====================
    Rectangle {
        id: listCard
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: statusBar.top
        color: "#FFFFFF"

        LogListView {
            id: logView
            anchors.fill: parent
            anchors.leftMargin: 1
            anchors.rightMargin: 1
            model: logModel
            keyword: toolBar.searchText
            blurSource: listCard
            scrollHost: listCard

            onMatchInfoChanged: matchInfo.text = info
            onDetailRequested: {
                detailPanel.rawText = rawLine
                detailPanel.open()
            }
        }
    }

    // ==================== 顶层：毛玻璃工具栏 ====================
    LogToolBar {
        id: toolBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        z: 10
        blurSource: listCard

        onOpenRequested: fileDialog.open()
        onLevelChanged: logModel.filterByLevel(level)
        onSearchChanged: logModel.search(keyword)
        onJumpFirstRequested: logView.gotoFirstMatch()
        onPrevRequested: logView.gotoPrev()
        onNextRequested: logView.gotoNext()
        onClearRequested: logModel.clear()
    }

    // ==================== 顶层：底部状态栏 ====================
    Rectangle {
        id: statusBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 30
        z: 10
        color: "#FF1E293B"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 16

            Text {
                text: "共 " + logModel.count + " 条"
                font.pixelSize: 12
                color: "#E2E8F0"
            }

            Text {
                id: matchInfo
                text: ""
                font.pixelSize: 12
                color: "#FBBF24"
            }

            Text {
                text: logModel.selectionCount > 0 ? "已选 " + logModel.selectionCount + " 条" : ""
                font.pixelSize: 12
                color: "#93C5FD"
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "日志查看器"
                font.pixelSize: 12
                color: "#64748B"
            }
        }
    }

    // ==================== 文件选择对话框 ====================
    FileDialog {
        id: fileDialog
        onAccepted: logModel.loadFile(fileUrl)
    }

    // ==================== 详情面板 ====================
    Dialog {
        id: detailPanel
        property string rawText: ""
        title: "日志详情"
        width: 640
        height: 420
        standardButtons: Dialog.Close
        // Qt 5.14 的 Dialog 无 background 属性，内容区直接铺圆角白底
        Rectangle {
            anchors.fill: parent
            color: "#FFFFFF"
            radius: 8
            TextArea {
                anchors.fill: parent
                anchors.margins: 12
                text: detailPanel.rawText
                readOnly: true
                font.family: "Consolas"
                font.pixelSize: 12
                wrapMode: TextArea.Wrap
            }
        }
    }

    // ==================== 拖放打开：把 .log / .txt 等文件拖进窗口即可 ====================
    DropArea {
        id: dropArea
        anchors.fill: parent
        onDropped: {
            if (drop.hasUrls && drop.urls.length > 0)
                logModel.loadFile(drop.urls[0])
        }
    }

    // 拖拽经过窗口时的提示遮罩
    Rectangle {
        anchors.fill: parent
        z: 100
        visible: dropArea.containsDrag
        color: "#990F172A"

        Text {
            anchors.centerIn: parent
            text: "松开鼠标打开文件\n.log / .txt 等文本日志"
            color: "white"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 1.4
        }
    }
}
