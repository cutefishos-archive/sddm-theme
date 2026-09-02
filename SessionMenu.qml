import QtQuick
import QtQuick.Controls as QQC2
import Qt5Compat.GraphicalEffects

import FishUI 1.0 as FishUI

Item {
    id: root

    property int currentIndex: -1
    property int rootFontSize: 10

    visible: sessionModel.count > 1
    implicitHeight: _currentLabel.implicitHeight
    implicitWidth: _currentLabel.implicitWidth + FishUI.Units.largeSpacing

    QQC2.ToolButton {
        id: button

        anchors.fill: parent
        hoverEnabled: true
        focusPolicy: Qt.NoFocus
        background: Item {}
        contentItem: Item {}

        onClicked: sessionMenu.popup(root, 0, -sessionMenu.height)
    }

    QQC2.Label {
        id: _currentLabel

        anchors.centerIn: parent
        color: "white"
        font.pointSize: root.rootFontSize
        text: {
            if (root.currentIndex < 0 || root.currentIndex >= instantiator.count)
                return ""

            var item = instantiator.objectAt(root.currentIndex)
            return item ? item.text : ""
        }
    }

    DropShadow {
        anchors.fill: _currentLabel
        source: _currentLabel
        z: -1
        horizontalOffset: 1
        verticalOffset: 1
        radius: 15
        samples: radius * 4
        spread: 0.35
        color: Qt.rgba(0, 0, 0, 0.2)
        opacity: 0.5
        visible: true
    }

    FishUI.Menu {
        id: sessionMenu

        Instantiator {
            id: instantiator

            model: sessionModel
            delegate: FishUI.MenuItem {
                text: model.name

                onTriggered: root.currentIndex = model.index
            }

            onObjectAdded: function(index, object) {
                sessionMenu.insertItem(index, object)
            }
            onObjectRemoved: function(index, object) {
                sessionMenu.removeItem(object)
            }
        }
    }

    Component.onCompleted: root.currentIndex = sessionModel.lastIndex
}
