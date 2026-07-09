import SwiftUI

extension View {
  func appShadow(_ definition: AppShadow.Definition) -> some View {
    shadow(
      color: definition.color,
      radius: definition.blur,
      x: definition.offsetX,
      y: definition.offsetY
    )
  }

  func appScreenBackground() -> some View {
    background(AppTheme.colors.background.ignoresSafeArea())
  }
}
