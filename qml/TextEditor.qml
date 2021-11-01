import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FishUI 1.0 as FishUI
import Cutefish.TextEditor 1.0

Item {
    id: control

    property alias fileUrl: document.fileUrl

    property bool showLineNumbers: true

    DocumentHandler {
        id: document
        document: body.textDocument
        cursorPosition: body.cursorPosition
        selectionStart: body.selectionStart
        selectionEnd: body.selectionEnd
        backgroundColor: FishUI.Theme.backgroundColor
        enableSyntaxHighlighting: true

        onSearchFound: {
            body.select(start, end)
        }

    }

    ScrollView {
        id: _scrollView
        anchors.fill: parent

        Keys.enabled: true
        Keys.forwardTo: body

        Flickable {
            id: _flickable
            boundsBehavior: Flickable.StopAtBounds
            boundsMovement: Flickable.StopAtBounds

            TextArea.flickable: TextArea {
                id: body
                text: document.text
                selectByKeyboard: true
                selectByMouse: true
                persistentSelection: true
                textFormat: TextEdit.PlainText
                wrapMode: TextEdit.WrapAnywhere

                activeFocusOnPress: true
                activeFocusOnTab: true

                leftPadding: _linesCounter.width + FishUI.Units.smallSpacing
                padding: FishUI.Units.smallSpacing
                color: FishUI.Theme.textColor

                font.family: "Noto Mono"

                background: Rectangle {
                    color: FishUI.Theme.backgroundColor
                }

                Loader {
                    id: _linesCounter
                    asynchronous: true
                    active: control.showLineNumbers && !document.isRich

                    anchors.left: parent.left
                    anchors.top: parent.top

                    height: Math.max(_flickable.contentHeight, control.height)
                    width: active ? 32 : 0

                    sourceComponent: _linesCounterComponent

                }
            }
        }
    }

    Component {
        id: _linesCounterComponent

        ListView {
            id: _linesCounterList
            anchors.fill: parent
            anchors.topMargin: body.topPadding + body.textMargin
            model: document.lineCount

            Binding on currentIndex {
                value: document.currentLineIndex
                restoreMode: Binding.RestoreBindingOrValue
            }

            Timer {
                id: _lineIndexTimer
                interval: 250
                onTriggered: _linesCounterList.currentIndex = document.currentLineIndex
            }

            Connections {
                target: document

                function onLineCountChanged() {
                    _lineIndexTimer.restart()
                }
            }

            orientation: ListView.Vertical
            interactive: false
            snapMode: ListView.NoSnap

            boundsBehavior: Flickable.StopAtBounds
            boundsMovement :Flickable.StopAtBounds

            preferredHighlightBegin: 0
            preferredHighlightEnd: width

            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 0
            highlightFollowsCurrentItem: false
            highlightResizeDuration: 0
            highlightMoveVelocity: -1
            highlightResizeVelocity: -1

            maximumFlickVelocity: 0

            delegate: Row {
                id: _delegate

                readonly property int line : index
                property bool foldable : control.document.isFoldable(line)

                width:  ListView.view.width
                height: Math.max(fontSize, document.lineHeight(line))

                readonly property real fontSize: control.body.font.pointSize
                readonly property bool isCurrentItem: ListView.isCurrentItem

//                Connections {
//                    target: control.body

//                    function onContentHeightChanged() {
//                        if (_delegate.isCurrentItem) {
//                            console.log("Updating line height")
//                            _delegate.height = control.document.lineHeight(_delegate.line)
//                            _delegate.foldable = control.document.isFoldable(_delegate.line)
//                        }
//                    }
//                }

                Label {
                    width: 32
                    height: parent.height
                    opacity: isCurrentItem ? 1 : 0.7
                    color: isCurrentItem ? FishUI.Theme.highlightColor
                                         : FishUI.Theme.textColor
                    font.pointSize: body.font.pointSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Monospace"
                    text: index + 1
                }
            }
        }
    }

    function forceActiveFocus() {
        body.forceActiveFocus()
    }

    function goToLine(line) {
        if (line > 0 && line <= body.lineCount) {
            body.cursorPosition = document.goToLine(line - 1)
            body.forceActiveFocus()
        }
    }
}
