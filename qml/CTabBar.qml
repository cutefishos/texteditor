import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FishUI 1.0 as FishUI

TabBar {
    id: control

    // property var model

    implicitWidth: _content.width

    default property alias content : _content.data
    property bool newTabVisibile: true

    signal newTabClicked()

    background: Rectangle {
        color: "transparent"
    }

    contentItem: Item {
        RowLayout {
            anchors.fill: parent
            spacing: FishUI.Units.smallSpacing

            ScrollView {
                id: _scrollView
                Layout.fillWidth: true
                Layout.fillHeight: true

                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                clip: true

                Flickable {
                    id: _flickable

                    Row {
                        id: _content
                        width: _scrollView.width
                        height: _scrollView.height
                    }
                }

            }

            Loader {
                active: control.newTabVisibile
                visible: active
                asynchronous: true
                Layout.fillHeight: true
                Layout.preferredWidth: visible ? height : 0

                sourceComponent: FishUI.RoundImageButton {
                    source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark/" : "light/") + "add.svg"
                    onClicked: control.newTabClicked()
                }
            }
        }
    }
}
