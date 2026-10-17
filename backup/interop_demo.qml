import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import com.demo 1.0

Window {
    visible: true
    width: 420
    height: 460
    title: "C++ ↔ QML 互操作"

    Column {
        anchors.centerIn: parent
        spacing: 16

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: backend.statusText                    // ② C++ 属性 → QML 绑定
            font.pixelSize: 18
            color: "#0C447C"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "counter = " + backend.counter
            color: "#5F5E5A"
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            Button {
                text: "+1"
                onClicked: backend.increment()          // ③ 调 C++ 方法
            }
            Button {
                text: "归零"
                onClicked: backend.reset()
            }
            Button {
                text: "写 42"
                onClicked: backend.counter = 42         // ② WRITE 通道：属性直接赋值
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 220
            height: 56
            radius: 8
            color: backend.counter % 2 === 0 ? "#E6F1FB" : "#CECBF6"   // 绑定驱动样式
            Text {
                anchors.centerIn: parent
                text: "背景色跟着 counter 奇偶自动变"
                font.pixelSize: 12
                color: "#3C3489"
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 220
            height: 44
            radius: 8
            color: "#F1EFE8"
            Text {
                anchors.centerIn: parent
                text: "QML 实例的 counter: " + localBackend.counter
                font.pixelSize: 12
                color: "#444441"
            }
        }

        Backend {                                      // ④ 注册类型当组件用
            id: localBackend
            counter: 100
        }
    }
}
