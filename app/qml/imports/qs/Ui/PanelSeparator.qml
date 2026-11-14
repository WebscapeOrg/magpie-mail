import QtQuick
import qs.Commons as Commons

// Invariant: Matches the shell's PanelSeparator: a one-pixel rule in the text colour at 12%,
// so the line under the top row stays faint whatever the theme's control colours are.
Rectangle {
  property color foreground: Commons.Color.foreground
  property real strength: 0.12

  width: parent ? parent.width : implicitWidth
  implicitWidth: 100
  implicitHeight: 1
  height: 1
  color: Qt.rgba(foreground.r, foreground.g, foreground.b, strength)
}
