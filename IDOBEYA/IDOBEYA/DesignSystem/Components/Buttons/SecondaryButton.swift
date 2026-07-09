import SwiftUI

struct SecondaryButton: View {
  let title: String
  var isDisabled: Bool = false
  let action: () -> Void

  private let height = AppTheme.spacing.huge

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(AppTheme.typography.presets.body.font())
        .fontWeight(AppTheme.typography.weights.semibold)
        .foregroundStyle(isDisabled ? AppTheme.colors.primary.opacity(0.4) : AppTheme.colors.primary)
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(AppTheme.colors.surface)
        .overlay(
          Capsule()
            .stroke(
              isDisabled ? AppTheme.colors.primary.opacity(0.4) : AppTheme.colors.primary,
              lineWidth: 1
            )
        )
        .clipShape(Capsule())
    }
    .buttonStyle(AppButtonPressStyle())
    .disabled(isDisabled)
    .accessibilityLabel(title)
    .accessibilityAddTraits(.isButton)
  }
}

#Preview {
  VStack(spacing: AppTheme.spacing.md) {
    SecondaryButton(title: "部屋を探す", action: {})
    SecondaryButton(title: "キャンセル", isDisabled: true, action: {})
  }
  .padding()
  .background(AppTheme.colors.background)
}
