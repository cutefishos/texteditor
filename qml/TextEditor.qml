import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FishUI 1.0 as FishUI
import Cutefish.TextEditor 1.0

Item {
    id: control

    property var tabName: document.fileName + (document.modified ? " *" : "")

    property alias fileUrl: document.fileUrl
    property alias fileName: document.fileName
    property bool showLineNumbers: true
    property int characterCount: body.text.length

    height: ListView.view ? ListView.view.height : 0
    width: ListView.view ? ListView.view.width : 0

    DocumentHandler {
        id: document
        document: body.textDocument
        cursorPosition: body.cursorPosition
        selectionStart: body.selectionStart
        selectionEnd: body.selectionEnd
        backgroundColor: FishUI.Theme.backgroundColor
        enableSyntaxHighlighting: true
        theme: FishUI.Theme.darkMode ? "Breeze Dark" : "Breeze Light"

        onSearchFound: {
            body.select(start, end)
        }

        onFileSaved: {
            root.showPassiveNotification(qsTr("Saved successfully"), 3000)
        }
    }

    ScrollView {
        id: _scrollView
        anchors.fill: parent

        Keys.enabled: true
        Keys.forwardTo: body

        contentWidth: availableWidth

        Flickable {
            id: _flickable

            FishUI.WheelHandler {
                id: wheelHandler
                target: _flickable
            }

            boundsBehavior: Flickable.StopAtBounds
            boundsMovement: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOff
            }

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

                Keys.enabled: true
                Keys.onPressed: {
                    if ((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_S)) {
                        control.save()
                        event.accepted = true
                    }
                }

                Loader {
                    id: _linesCounter
                    active: control.showLineNumbers && !document.isRich
                    asynchronous: true

                    anchors.left: body.left
                    anchors.top: body.top
                    anchors.topMargin: body.topPadding + body.textMargin

                    height: _flickable.contentHeight
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
            model: document.lineCount
            clip: true

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
                // property bool foldable : control.document.isFoldable(line)

                width:  ListView.view.width
                height: document.lineHeight(line)

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

    function save() {
        document.saveAs(document.fileUrl)
    }
}
