import SwiftUI

struct NotificationRow: View {
  let notification: NotificationItem
  var onTap: (() -> Void)?

  var body: some View {
    Group {
      if let onTap {
        Button(action: onTap) { rowContent }
          .buttonStyle(.plain)
      } else {
        rowContent
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel(accessibilitySummary)
  }

  private var rowContent: some View {
    HStack(alignment: .top, spacing: AppTheme.spacing.sm) {
      if !notification.isRead {
        unreadDot
          .padding(.top, AppTheme.spacing.sm)
      } else {
        Color.clear
          .frame(width: AppTheme.spacing.xs, height: AppTheme.spacing.xs)
          .padding(.top, AppTheme.spacing.sm)
      }

      typeIcon

      VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
        Text(notification.title)
          .font(AppTheme.typography.presets.body.font())
          .fontWeight(notification.isRead ? AppTheme.typography.weights.regular : AppTheme.typography.weights.medium)
          .foregroundStyle(notification.isRead ? AppTheme.colors.textSecondary : AppTheme.colors.textPrimary)
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)

        if let body = notification.body {
          Text(body)
            .font(AppTheme.typography.presets.caption.font())
            .foregroundStyle(AppTheme.colors.textSecondary)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
        }

        Text(relativeDateString(from: notification.createdAt))
          .font(AppTheme.typography.presets.caption.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
          .padding(.top, AppTheme.spacing.xxs)
      }

      Spacer(minLength: 0)
    }
    .padding(AppTheme.spacing.md)
    .background(rowBackground)
    .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large))
    .overlay(
      RoundedRectangle(cornerRadius: AppTheme.radius.large)
        .stroke(AppTheme.colors.border, lineWidth: notification.isRead ? 1 : 0)
    )
  }

  private var unreadDot: some View {
    Circle()
      .fill(AppTheme.colors.primary)
      .frame(width: AppTheme.spacing.xs, height: AppTheme.spacing.xs)
      .accessibilityHidden(true)
  }

  private var typeIcon: some View {
    Image(systemName: notification.type.systemImageName)
      .font(.system(size: AppTheme.typography.sizes.body, weight: AppTheme.typography.weights.medium))
      .foregroundStyle(iconForeground)
      .frame(width: AppTheme.spacing.xxl, height: AppTheme.spacing.xxl)
      .background(iconBackground)
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.medium))
  }

  private var rowBackground: Color {
    notification.isRead ? AppTheme.colors.surface : AppTheme.colors.primary.opacity(0.06)
  }

  private var iconForeground: Color {
    switch notification.type.iconTintKey {
    case .primary: AppTheme.colors.primary
    case .accent: AppTheme.colors.accent
    case .secondary: AppTheme.colors.textSecondary
    }
  }

  private var iconBackground: Color {
    switch notification.type.iconTintKey {
    case .primary: AppTheme.colors.primary.opacity(0.12)
    case .accent: AppTheme.colors.accent.opacity(0.12)
    case .secondary: AppTheme.colors.textSecondary.opacity(0.12)
    }
  }

  private var accessibilitySummary: String {
    let readState = notification.isRead ? "既読" : "未読"
    if let body = notification.body {
      return "\(readState)、\(notification.title)、\(body)"
    }
    return "\(readState)、\(notification.title)"
  }

  private func relativeDateString(from date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.locale = Locale(identifier: "ja_JP")
    formatter.unitsStyle = .short
    return formatter.localizedString(for: date, relativeTo: Date())
  }
}

#Preview {
  VStack(spacing: AppTheme.spacing.sm) {
    NotificationRow(notification: MockNotifications.all[0])
    NotificationRow(notification: MockNotifications.all[1])
    NotificationRow(notification: MockNotifications.all[2])
  }
  .padding()
  .background(AppTheme.colors.background)
}
