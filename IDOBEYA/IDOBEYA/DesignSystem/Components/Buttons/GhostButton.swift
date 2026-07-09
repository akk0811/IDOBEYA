import SwiftUI

struct GhostButton: View {
  enum Style {
    case primary
    case secondary
  }

  let title: String
  var style: Style = .primary
  var isDisabled: Bool = false
  let action: () -> Void

  private var foregroundColor: Color {
    switch style {
    case .primary:
      isDisabled ? AppTheme.colors.primary.opacity(0.4) : AppTheme.colors.primary
    case .secondary:
      isDisabled ? AppTheme.colors.textSecondary.opacity(0.4) : AppTheme.colors.textSecondary
    }
  }

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(AppTheme.typography.presets.body.font())
        .fontWeight(AppTheme.typography.weights.medium)
        .foregroundStyle(foregroundColor)
        .frame(maxWidth: .infinity)
        .frame(height: AppTheme.spacing.huge)
    }
    .buttonStyle(AppButtonPressStyle())
    .disabled(isDisabled)
    .accessibilityLabel(title)
    .accessibilityAddTraits(.isButton)
  }
}

#Preview {
  VStack(spacing: AppTheme.spacing.md) {
    GhostButton(title: "戻る", action: {})
    GhostButton(title: "キャンセル", style: .secondary, action: {})
  }
  .padding()
  .background(AppTheme.colors.background)
}
