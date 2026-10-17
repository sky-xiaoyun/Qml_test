import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Window {
    visible: true
    width: 420
    height: 520
    title: "Card 列表 · 数据驱动"

    ListModel {
        id: cardModel
        ListElement { name: "卡片 A"; cardColor: "#EEEDFE" }
        ListElement { name: "卡片 B"; cardColor: "#E1F5EE" }
        ListElement { name: "卡片 C"; cardColor: "#FCEBEB" }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Button {
                text: "添加"
                onClicked: cardModel.append({ name: "新卡片 " + cardModel.count, cardColor: "#FAEEDA" })
            }
            Button {
                text: "删除末项"
                enabled: cardModel.count > 0
                onClicked: cardModel.remove(cardModel.count - 1)
            }
            Item { Layout.fillWidth: true }
            Text { text: "共 " + cardModel.count + " 项"; color: "#5F5E5A" }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: cardModel
            spacing: 10
            clip: true
            delegate: Card {
                width: ListView.view.width        // 附加属性够到 ListView
                height: 88
                draggable: false                  // 列表里不拖（避免和定位打架）
                cardName: name                    // 角色注入
                labelText: name
                normalColor: cardColor
                hoverColor: "#CECBF6"
                onClicked: ListView.view.currentIndex = index
                scale: ListView.isCurrentItem ? 1.05 : 1.0   // 选中项放大
                Behavior on scale { NumberAnimation { duration: 150 } }
            }
        }
    }
}
