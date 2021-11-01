import QtQuick 2.15
import QtQuick.Window 2.15
import FishUI 1.0 as FishUI

FishUI.Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    TextEditor {
        anchors.fill: parent
        fileUrl: "file:///home/reion/Cutefish/core/notificationd/view.cpp"
    }
}
