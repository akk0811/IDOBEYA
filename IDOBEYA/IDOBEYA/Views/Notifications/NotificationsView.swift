import SwiftUI

struct NotificationsView: View {
  @StateObject private var viewModel: NotificationsViewModel<MockAppStore>

  init(store: MockAppStore) {
    _viewModel = StateObject(wrappedValue: NotificationsViewModel(store: store))
  }

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        IDOSegmentControl(
          items: NotificationsViewModel<MockAppStore>.Filter.allCases,
          selection: $viewModel.selectedFilter,
          title: \.rawValue
        )
        .padding(.horizontal, Theme.Spacing.screen)
        .padding(.vertical, Theme.Spacing.sm)
        .background(Theme.Color.surface)

        ScrollView {
          LazyVStack(spacing: Theme.Spacing.sm) {
            if viewModel.filteredNotifications.isEmpty {
              IDOEmptyState(
                icon: "bell",
                title: "通知はありません",
                message: "いいねやコメントがあるとここに表示されます"
              )
              .padding(.top, Theme.Spacing.xxl + Theme.Spacing.xs)
            } else {
              ForEach(viewModel.filteredNotifications) { notification in
                IDONotificationCard(notification: notification)
              }
            }
          }
          .padding(Theme.Spacing.screen)
        }
      }
      .idoScreenBackground()
      .navigationTitle("通知")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}
