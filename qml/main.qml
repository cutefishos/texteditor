import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FishUI 1.0 as FishUI

FishUI.Window {
    width: 640
    height: 480
    minimumWidth: 300
    minimumHeight: 300
    visible: true
    title: qsTr("Text Editor")

    headerItem: Item {
        TabBar {
            anchors.fill: parent
            anchors.margins: FishUI.Units.smallSpacing / 2

            currentIndex : _tabView.currentIndex

            Repeater {
                id: _repeater
                model: _tabView.count

                TabButton {
                    text: _tabView.contentModel.get(index).fileName
                    implicitHeight: parent.height
                    implicitWidth: Math.max(parent.width / _repeater.count, 200)

                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    hoverEnabled: true

                    ToolTip.visible: hovered
                    ToolTip.text: _tabView.contentModel.get(index).fileUrl

                    leftPadding: FishUI.Units.smallSpacing
                    rightPadding: FishUI.Units.smallSpacing

                    onClicked: {
                        _tabView.currentIndex = index
                        _tabView.currentItem.forceActiveFocus()
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TabView {
            id: _tabView
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Item {
            id: _bottomItem
            z: 999
            Layout.fillWidth: true
            Layout.preferredHeight: 20 + FishUI.Units.smallSpacing

            Rectangle {
                anchors.fill: parent
                color: FishUI.Theme.backgroundColor
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: FishUI.Units.smallSpacing
                anchors.rightMargin: FishUI.Units.smallSpacing
                anchors.bottomMargin: FishUI.Units.smallSpacing

                Label {
                    text: qsTr("Characters %1").arg(_tabView.currentItem.characterCount)
                }
            }
        }
    }

    function addTab() {
        _tabView.addTab(textEditorCompeont, {})
    }

    Component {
        id: textEditorCompeont

        TextEditor {
            fileUrl: "file:///home/reion/Cutefish/core/notificationd/view.cpp"
        }
    }

    Component.onCompleted: {
        addTab()
        addTab()
        addTab()
    }
}
