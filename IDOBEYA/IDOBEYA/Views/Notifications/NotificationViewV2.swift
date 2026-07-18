import SwiftUI

// MARK: - Notification Screen

/// Design System v1.0 ベースの通知画面（STEP8）
///
/// STEP15 より `MainTabView` の通知タブで使用。Preview 単体確認時は `showBottomTabBar: true`（既定）。
struct NotificationViewV2: View {
  let showBottomTabBar: Bool

  @State private var notificationItems: [NotificationItem]
  @State private var selectedCategory: NotificationFilter = .all
  @State private var selectedTab = BottomTabBar.Tab.notifications
  @State private var toast: AppToastData?

  init(
    notifications: [NotificationItem] = MockNotifications.all,
    showBottomTabBar: Bool = true
  ) {
    self.showBottomTabBar = showBottomTabBar
    _notificationItems = State(initialValue: notifications)
  }

  private var filteredNotifications: [NotificationItem] {
    MockNotifications.filtered(by: selectedCategory, from: notificationItems)
  }

  var body: some View {
    VStack(spacing: 0) {
      AppHeader(
        title: "通知",
        trailingIcon: "checkmark.circle",
        trailingAccessibilityLabel: "すべて既読",
        onTrailingTap: markAllAsRead
      )

      ScrollView {
        VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
          categorySection
          notificationListSection
        }
        .padding(.horizontal, AppTheme.spacing.lg)
        .padding(.top, AppTheme.spacing.sm)
        .padding(.bottom, AppTheme.spacing.xl)
      }

      if showBottomTabBar {
        BottomTabBar(selection: $selectedTab)
      }
    }
    .background(AppTheme.colors.background)
    .appToast($toast)
  }

  // MARK: - Categories

  private var categorySection: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: AppTheme.spacing.xs) {
        ForEach(NotificationFilter.allCases) { category in
          AppChip(
            title: category.rawValue,
            isSelected: selectedCategory == category,
            action: { selectedCategory = category }
          )
        }
      }
      .padding(.vertical, AppTheme.spacing.xxs)
    }
    .accessibilityLabel("通知カテゴリ")
  }

  // MARK: - List

  private var notificationListSection: some View {
    Group {
      if filteredNotifications.isEmpty {
        emptyContent
      } else {
        VStack(spacing: AppTheme.spacing.sm) {
          ForEach(filteredNotifications) { notification in
            NotificationRow(
              notification: notification,
              onTap: { markAsRead(notification) }
            )
          }
        }
      }
    }
  }

  private var emptyContent: some View {
    EmptyStateView(preset: .noNotifications)
      .padding(.top, AppTheme.spacing.xl)
  }

  // MARK: - Actions

  private func markAsRead(_ notification: NotificationItem) {
    guard !notification.isRead,
          let index = notificationItems.firstIndex(where: { $0.id == notification.id })
    else {
      return
    }

    withAnimation(AppTheme.animation.presets.transition.animation) {
      notificationItems[index] = notification.markingAsRead()
    }
  }

  private func markAllAsRead() {
    guard notificationItems.contains(where: { !$0.isRead }) else { return }

    withAnimation(AppTheme.animation.presets.transition.animation) {
      notificationItems = notificationItems.map { $0.markingAsRead() }
    }
    toast = AppToastData(
      message: "すべて確認済みにしました",
      style: .info
    )
  }
}

private extension NotificationItem {
  func markingAsRead() -> NotificationItem {
    NotificationItem(
      id: id,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: true
    )
  }
}

// MARK: - Previews

#Preview("Notification V2") {
  NotificationViewV2()
}

#Preview("Notification V2 — Empty") {
  NotificationViewV2(notifications: [])
}

#Preview("Notification V2 — Likes Only") {
  NotificationViewV2(
    notifications: MockNotifications.filtered(by: .like)
  )
}

#Preview("Notification V2 — All Read") {
  NotificationViewV2(
    notifications: MockNotifications.all.map {
      NotificationItem(
        id: $0.id,
        type: $0.type,
        title: $0.title,
        body: $0.body,
        createdAt: $0.createdAt,
        isRead: true
      )
    }
  )
}

#Preview("Notification V2 — Dark") {
  NotificationViewV2()
    .preferredColorScheme(.dark)
}

#Preview("Notification V2 — Large Text") {
  NotificationViewV2()
    .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}
