import SwiftUI

struct IconCircleButton: View {
  enum BackgroundStyle {
    case surface
    case background
  }

  let systemName: String
  var backgroundStyle: BackgroundStyle = .surface
  var accessibilityLabel: String
  let action: () -> Void

  private let size = AppTheme.spacing.huge

  private var backgroundColor: Color {
    switch backgroundStyle {
    case .surface: AppTheme.colors.surface
    case .background: AppTheme.colors.background
    }
  }

  var body: some View {
    Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: AppTheme.typography.sizes.body, weight: AppTheme.typography.weights.medium))
        .foregroundStyle(AppTheme.colors.textPrimary)
        .frame(width: size, height: size)
        .background(backgroundColor)
        .clipShape(Circle())
        .appShadow(AppTheme.shadow.small)
    }
    .buttonStyle(AppButtonPressStyle())
    .accessibilityLabel(accessibilityLabel)
    .accessibilityAddTraits(.isButton)
  }
}

#Preview {
  HStack(spacing: AppTheme.spacing.md) {
    IconCircleButton(systemName: "bell", accessibilityLabel: "通知", action: {})
    IconCircleButton(systemName: "chevron.left", backgroundStyle: .background, accessibilityLabel: "戻る", action: {})
    IconCircleButton(systemName: "gearshape", accessibilityLabel: "設定", action: {})
  }
  .padding()
  .background(AppTheme.colors.background)
}
