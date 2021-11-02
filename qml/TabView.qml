import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FishUI 1.0 as FishUI

Container {
    id: control

    spacing: 0

    contentItem: ColumnLayout {
        spacing: 0

        ListView {
            id: _view
            Layout.fillWidth: true
            Layout.fillHeight: true
            interactive: false
            orientation: ListView.Horizontal
            snapMode: ListView.SnapOneItem
            currentIndex: control.currentIndex

            model: control.contentModel

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

    function closeTab(index) {
        control.removeItem(control.takeItem(index))
        control.currentItemChanged()
        control.currentItem.forceActiveFocus()
    }

    function addTab(component, properties) {
        const object = component.createObject(control.contentModel, properties)

        control.addItem(object)
        control.currentIndex = Math.max(control.count - 1, 0)
        object.forceActiveFocus()

        return object
    }
}
