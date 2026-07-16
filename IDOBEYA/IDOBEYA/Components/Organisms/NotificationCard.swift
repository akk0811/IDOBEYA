import SwiftUI

struct IDONotificationCard: View {
  let notification: AppNotification

  var body: some View {
    HStack(alignment: .top, spacing: AppTheme.spacing.sm) {
      ZStack {
        Circle()
          .fill(notification.isRead ? AppTheme.colors.border.opacity(0.5) : AppTheme.colors.primary.opacity(0.08))
          .frame(width: AppTheme.iconSize.notification, height: AppTheme.iconSize.notification)
        Image(systemName: notification.type.icon)
          .font(AppFont.caption(.medium))
          .foregroundStyle(notification.isRead ? AppTheme.colors.textSecondary : AppTheme.colors.primary)
      }
      .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
        Text(notification.title)
          .font(AppFont.body(notification.isRead ? .regular : .semibold))
          .foregroundStyle(AppTheme.colors.textPrimary)
        if !notification.body.isEmpty {
          Text(notification.body)
            .font(AppFont.caption())
            .foregroundStyle(AppTheme.colors.textSecondary)
            .lineLimit(2)
        }
        Text(notification.createdAt, style: .relative)
          .font(AppFont.caption())
          .foregroundStyle(AppTheme.colors.textSecondary)
      }

      if !notification.isRead {
        IDOBadge(variant: .dot)
          .accessibilityLabel("未読")
      }
    }
    .padding(AppTheme.spacing.md)
    .background(notification.isRead ? AppTheme.colors.surface : AppTheme.colors.primary.opacity(0.08))
    .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large, style: .continuous))
    .accessibilityElement(children: .combine)
    .accessibilityLabel(notificationAccessibilityLabel)
  }

  private var notificationAccessibilityLabel: String {
    let readStatus = notification.isRead ? "" : "未読。"
    let body = notification.body.isEmpty ? "" : notification.body
    return "\(readStatus)\(notification.title)。\(body)"
  }
}

typealias IDONotificationRow = IDONotificationCard
