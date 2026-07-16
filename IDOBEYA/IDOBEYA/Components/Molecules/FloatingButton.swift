import SwiftUI

struct IDOFloatingButton: View {
  let icon: String
  let title: String?
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: AppTheme.spacing.xs) {
        Image(systemName: icon)
        if let title {
          Text(title)
            .font(AppFont.body())
        }
      }
      .foregroundStyle(AppTheme.colors.textSecondary)
      .padding(.horizontal, title == nil ? AppTheme.spacing.md : AppTheme.spacing.lg)
      .padding(.vertical, AppTheme.spacing.md)
      .background(AppTheme.colors.surface)
      .clipShape(Capsule())
      .appShadow(AppTheme.shadow.small)
    }
    .buttonStyle(AppButtonPressStyle())
  }
}
