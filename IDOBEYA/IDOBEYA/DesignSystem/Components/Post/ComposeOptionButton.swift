import SwiftUI

struct ComposeOptionButton: View {
  let title: String
  let systemImage: String
  var isDisabled: Bool = false
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: AppTheme.spacing.xs) {
        Image(systemName: systemImage)
          .font(.system(size: AppTheme.typography.sizes.body, weight: AppTheme.typography.weights.medium))
          .foregroundStyle(iconColor)
          .frame(width: AppTheme.spacing.xxl, height: AppTheme.spacing.xxl)
          .background(iconBackground)
          .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.medium))
          .overlay(
            RoundedRectangle(cornerRadius: AppTheme.radius.medium)
              .stroke(AppTheme.colors.border, lineWidth: 1)
          )

        Text(title)
          .font(AppTheme.typography.presets.caption.font())
          .foregroundStyle(labelColor)
          .lineLimit(1)
          .minimumScaleFactor(0.85)
      }
      .frame(maxWidth: .infinity)
      .contentShape(Rectangle())
    }
    .buttonStyle(AppButtonPressStyle())
    .disabled(isDisabled)
    .opacity(isDisabled ? 0.55 : 1)
    .accessibilityLabel(title)
  }

  private var iconColor: Color {
    isDisabled ? AppTheme.colors.textSecondary : AppTheme.colors.primary
  }

  private var labelColor: Color {
    isDisabled ? AppTheme.colors.textSecondary : AppTheme.colors.textPrimary
  }

  private var iconBackground: Color {
    isDisabled ? AppTheme.colors.background : AppTheme.colors.primary.opacity(0.08)
  }
}

#Preview {
  HStack(spacing: AppTheme.spacing.md) {
    ComposeOptionButton(title: "画像", systemImage: "photo", action: {})
    ComposeOptionButton(title: "アンケート", systemImage: "chart.bar", isDisabled: true, action: {})
    ComposeOptionButton(title: "絵文字", systemImage: "face.smiling", action: {})
  }
  .padding()
  .background(AppTheme.colors.background)
}
