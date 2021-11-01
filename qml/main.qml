import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FishUI 1.0 as FishUI

FishUI.Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Text Editor")

    headerItem: Item {
        TabBar {
            anchors.fill: parent

            currentIndex : _container.currentIndex

            Repeater {
                id: _repeater
                model: _container.count

                TabButton {
                    text: _container.contentModel.get(index).fileName
                    implicitHeight: parent.height
                    implicitWidth: Math.max(parent.width / _repeater.count, 200)

                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    hoverEnabled: true

                    ToolTip.visible: hovered
                    ToolTip.text: _container.contentModel.get(index).fileUrl

                    leftPadding: FishUI.Units.smallSpacing
                    rightPadding: FishUI.Units.smallSpacing

                    onClicked: {
                        _container.currentIndex = index
                        _container.currentItem.forceActiveFocus()
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Container {
            id: _container

            Layout.fillWidth: true
            Layout.fillHeight: true

            contentItem: ColumnLayout {
                spacing: 0

                ListView {
                    id: _view
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    interactive: false
                    orientation: ListView.Horizontal
                    snapMode: ListView.SnapOneItem
                    currentIndex: _container.currentIndex

                    model: _container.contentModel

                    boundsBehavior: Flickable.StopAtBounds
                    boundsMovement :Flickable.StopAtBounds

                    spacing: 0

                    preferredHighlightBegin: 0
                    preferredHighlightEnd: width

                    highlightRangeMode: ListView.StrictlyEnforceRange
                    highlightMoveDuration: 0
                    highlightFollowsCurrentItem: true
                    highlightResizeDuration: 0
                    highlightMoveVelocity: -1
                    highlightResizeVelocity: -1

                    maximumFlickVelocity: 4 * width

                    cacheBuffer: _view.count * width
                    keyNavigationEnabled : false
                    keyNavigationWraps : false
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 20

            ColumnLayout {
                anchors.fill: parent
            }
        }
    }

    function addTab() {
        const component = textEditorCompeont
        const object = component.createObject(_container.contentModel)

        _container.addItem(object)
        _container.currentIndex = Math.max(_container.count - 1, 0)
        object.forceActiveFocus()
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
