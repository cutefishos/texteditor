import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FishUI 1.0 as FishUI

FishUI.Window {
    id: root
    width: 640
    height: 480
    minimumWidth: 300
    minimumHeight: 300
    visible: true
    title: qsTr("Text Editor")

    headerItem: Item {
        Rectangle {
            anchors.fill: parent
            color: FishUI.Theme.backgroundColor
        }

        CTabBar {
            id: _tabbar
            anchors.fill: parent
            anchors.margins: FishUI.Units.smallSpacing / 2
            anchors.rightMargin: FishUI.Units.largeSpacing * 2

            currentIndex : _tabView.currentIndex

            onNewTabClicked: {
                addTab()
            }

            Repeater {
                id: _repeater
                model: _tabView.count

                CTabButton {
                    text: _tabView.contentModel.get(index).fileName
                    implicitHeight: parent.height
                    implicitWidth: _repeater.count === 1 ? 150
                                                         : parent.width / _repeater.count

                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000

                    checked: _tabView.currentIndex == index

                    ToolTip.visible: hovered
                    ToolTip.text: _tabView.contentModel.get(index).fileUrl

                    onClicked: {
                        _tabView.currentIndex = index
                        _tabView.currentItem.forceActiveFocus()
                    }

                    onCloseClicked: {
                        _tabView.closeTab(index)
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
            fileUrl: ""
        }
    }

    Component.onCompleted: {
        addTab()
    }
}
