import QtQuick 2.14
import QtQuick.Controls 2.14
import "."

// 深色工具栏上的扁平文字按钮（↑ / ↓ / 清空 复用）
Button {
    id: control
    flat: true
    font.pixelSize: 13

    background: Rectangle {
        implicitHeight: 30
        radius: 6
        color: parent.down ? Theme.barDown
             : (parent.hovered ? Theme.hoverBar : "transparent")
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    contentItem: Text {
        text: control.text
        color: Theme.barText
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
