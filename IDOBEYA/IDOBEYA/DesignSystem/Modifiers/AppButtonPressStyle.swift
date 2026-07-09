import SwiftUI

struct AppButtonPressStyle: ButtonStyle {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.97 : 1)
      .animation(
        reduceMotion ? nil : AppTheme.animation.presets.press.animation,
        value: configuration.isPressed
      )
  }
}
