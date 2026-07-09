import SwiftUI

struct PrimaryButton: View {
  let title: String
  var isDisabled: Bool = false
  var isLoading: Bool = false
  let action: () -> Void

  private let height = AppTheme.spacing.huge

  var body: some View {
    Button(action: action) {
      HStack(spacing: AppTheme.spacing.xs) {
        if isLoading {
          ProgressView()
            .tint(AppTheme.colors.surface)
        }
        Text(title)
          .font(AppTheme.typography.presets.body.font())
          .fontWeight(AppTheme.typography.weights.semibold)
      }
      .foregroundStyle(AppTheme.colors.surface)
      .frame(maxWidth: .infinity)
      .frame(height: height)
      .background(isDisabled ? AppTheme.colors.primary.opacity(0.4) : AppTheme.colors.primary)
      .clipShape(Capsule())
    }
    .buttonStyle(AppButtonPressStyle())
    .disabled(isDisabled || isLoading)
    .accessibilityLabel(title)
    .accessibilityAddTraits(.isButton)
  }
}

#Preview {
  VStack(spacing: AppTheme.spacing.md) {
    PrimaryButton(title: "投稿する", action: {})
    PrimaryButton(title: "保存する", isDisabled: true, action: {})
    PrimaryButton(title: "参加する", isLoading: true, action: {})
  }
  .padding()
  .background(AppTheme.colors.background)
}
