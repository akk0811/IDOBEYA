import SwiftUI

struct IDOEmptyState: View {
  let icon: String
  let title: String
  let message: String
  var actionTitle: String?
  var action: (() -> Void)?

  var body: some View {
    VStack(spacing: AppTheme.spacing.sm) {
      Image(systemName: icon)
        .font(.system(size: AppTheme.iconSize.empty))
        .foregroundStyle(AppTheme.colors.primary.opacity(0.6))
        .accessibilityHidden(true)
      Text(title)
        .font(AppFont.heading())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .multilineTextAlignment(.center)
      Text(message)
        .font(AppFont.body())
        .foregroundStyle(AppTheme.colors.textSecondary)
        .multilineTextAlignment(.center)
        .lineSpacing(AppTheme.spacing.xxs)
      if let actionTitle, let action {
        IDOButton(title: actionTitle, style: .secondary, isFullWidth: false, action: action)
          .padding(.top, AppTheme.spacing.xs)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(AppTheme.spacing.xxl)
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(title)。\(message)")
  }
}
