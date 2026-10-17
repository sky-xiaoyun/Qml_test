import QtQuick 2.14

Rectangle {
    id: card
    width: 160
    height: 100
    radius: 10

    property alias labelText: label.text          // 对外暴露：文字
    property color normalColor: "#EEEDFE"        // 对外暴露：常态色
    property color hoverColor: "#CECBF6"         // 对外暴露：悬停色
    property string cardName: "卡片"              // 对外暴露：名字

    signal dropped(real px, real py)              // 对外信号：拖拽结束
    signal resetRequested()                       // 对外信号：请求复位

    color: mouseArea.containsMouse ? hoverColor : normalColor

    Text {
        id: label
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 1.3
        color: "#3C3489"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        drag.target: draggable ? card : null
        focus: true                               // 参与初始焦点竞争（启动时先创建者获焦）
        onPressed: forceActiveFocus()             // 关键：MouseArea 点击不自动抢焦点，必须手动
        onClicked: card.clicked()
        onDoubleClicked: card.resetRequested()
        onReleased: card.dropped(card.x, card.y)
        Keys.onLeftPressed: card.x -= 12
        Keys.onRightPressed: card.x += 12
        Keys.onUpPressed: card.y -= 12
        Keys.onDownPressed: card.y += 12
        Keys.onEscapePressed: card.resetRequested()
        // MouseArea 内：

    }

    property bool selected: false                    // 选中态数据

    scale: selected ? 1.08 : 1.0                     // 绑定决定“值”
    Behavior on scale {                              // Behavior 决定“怎么变”
        NumberAnimation { duration: 180; easing.type: Easing.OutQuad }
    }

    states: State {
        when: selected                               // 条件为真自动切入，无需手动赋值
        name: "selected"
        PropertyChanges { target: card; border.width: 3; z: 10 }
    }

    signal clicked()
    property bool draggable: true

}
