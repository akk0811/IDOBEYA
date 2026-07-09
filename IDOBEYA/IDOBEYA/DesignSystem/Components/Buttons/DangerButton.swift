import SwiftUI

struct DangerButton: View {
  let title: String
  var isDisabled: Bool = false
  let action: () -> Void

  private let height = AppTheme.spacing.huge

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(AppTheme.typography.presets.body.font())
        .fontWeight(AppTheme.typography.weights.semibold)
        .foregroundStyle(AppTheme.colors.surface)
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(isDisabled ? AppTheme.colors.error.opacity(0.4) : AppTheme.colors.error)
        .clipShape(Capsule())
    }
    .buttonStyle(AppButtonPressStyle())
    .disabled(isDisabled)
    .accessibilityLabel(title)
    .accessibilityAddTraits(.isButton)
  }
}

#Preview {
  DangerButton(title: "部屋から退出する", action: {})
    .padding()
    .background(AppTheme.colors.background)
}
