import SwiftUI

struct IDONotificationCard: View {
  let notification: AppNotification

  var body: some View {
    HStack(alignment: .top, spacing: Theme.Spacing.sm) {
      ZStack {
        Circle()
          .fill(notification.isRead ? Theme.Color.border.opacity(0.5) : Theme.Color.unreadBackground)
          .frame(width: Theme.IconSize.notification, height: Theme.IconSize.notification)
        Image(systemName: notification.type.icon)
          .font(IDOFont.caption(.medium))
          .foregroundStyle(notification.isRead ? Theme.Color.textSecondary : Theme.Color.primary)
      }
      .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
        Text(notification.title)
          .font(IDOFont.body(notification.isRead ? .regular : .semibold))
          .foregroundStyle(Theme.Color.text)
        if !notification.body.isEmpty {
          Text(notification.body)
            .font(IDOFont.caption())
            .foregroundStyle(Theme.Color.textSecondary)
            .lineLimit(2)
        }
        Text(notification.createdAt, style: .relative)
          .font(IDOFont.caption())
          .foregroundStyle(Theme.Color.textSecondary)
      }

      if !notification.isRead {
        IDOBadge(variant: .dot)
          .accessibilityLabel("未読")
      }
    }
    .padding(Theme.Spacing.md)
    .background(notification.isRead ? Theme.Color.surface : Theme.Color.unreadBackground)
    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous))
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
