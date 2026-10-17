import QtQuick 2.14
import QtQuick.Controls 2.14

// 深色工具栏上的扁平文字按钮（打开文件/↑/↓/清空 复用）
// 颜色随深色栏硬编码，改样式只改这一处
Button {
    id: control
    flat: true
    font.pixelSize: 13

    background: Rectangle {
        implicitHeight: 30
        radius: 6
        color: parent.down ? "#0F172A"
             : (parent.hovered ? "#334155" : "#2563EB")
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    contentItem: Text {
        text: control.text
        color: "#E2E8F0"
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
