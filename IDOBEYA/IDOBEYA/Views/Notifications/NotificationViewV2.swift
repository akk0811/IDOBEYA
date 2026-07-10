import SwiftUI

/// Design System v1.0 ベースの通知画面（STEP8）
///
/// 本番導線には未組み込み。`MainTabView` は従来の `NotificationsView` を使用します。
struct NotificationViewV2: View {
  let notifications: [NotificationItem]

  @State private var selectedCategory: NotificationFilter = .all
  @State private var selectedTab = BottomTabBar.Tab.notifications

  init(notifications: [NotificationItem] = MockNotifications.all) {
    self.notifications = notifications
  }

  private var filteredNotifications: [NotificationItem] {
    MockNotifications.filtered(by: selectedCategory, from: notifications)
  }

  var body: some View {
    VStack(spacing: 0) {
      AppHeader(
        title: "通知",
        trailingIcon: "checkmark.circle",
        trailingAccessibilityLabel: "すべて既読",
        onTrailingTap: {}
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

      BottomTabBar(selection: $selectedTab)
    }
    .background(AppTheme.colors.background)
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
            NotificationRow(notification: notification, onTap: {})
          }
        }
      }
    }
  }

  private var emptyContent: some View {
    EmptyStateView(
      iconName: "bell.slash",
      title: "通知はありません",
      message: "新しい反応やお知らせが届くとここに表示されます"
    )
    .padding(.top, AppTheme.spacing.xl)
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
