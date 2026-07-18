import SwiftUI

struct AppChip: View {
  let title: String
  var systemImage: String?
  var isSelected: Bool = false
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: AppTheme.spacing.xxs) {
        if let systemImage {
          Image(systemName: systemImage)
            .font(.system(size: AppTheme.typography.sizes.caption, weight: AppTheme.typography.weights.medium))
            .accessibilityHidden(true)
        }
        Text(title)
          .font(AppTheme.typography.presets.caption.font())
          .fontWeight(AppTheme.typography.weights.medium)
          .lineLimit(2)
          .multilineTextAlignment(.center)
          .fixedSize(horizontal: false, vertical: true)
      }
      .foregroundStyle(isSelected ? AppTheme.colors.surface : AppTheme.colors.textPrimary)
      .padding(.horizontal, AppTheme.spacing.sm)
      .padding(.vertical, AppTheme.spacing.xs)
      .frame(minHeight: AppTheme.spacing.minTapTarget)
      .background(isSelected ? AppTheme.colors.primary : AppTheme.colors.surface)
      .overlay(
        Capsule()
          .stroke(isSelected ? AppTheme.colors.primary : AppTheme.colors.border, lineWidth: 1)
      )
      .clipShape(Capsule())
      .contentShape(Capsule())
    }
    .buttonStyle(AppButtonPressStyle())
    .accessibilityLabel(title)
    .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
  }
}

#Preview {
  HStack(spacing: AppTheme.spacing.xs) {
    AppChip(title: "趣味", isSelected: true, action: {})
    AppChip(title: "相談", action: {})
    AppChip(title: "生活", systemImage: "house", action: {})
  }
  .padding()
  .background(AppTheme.colors.background)
}
