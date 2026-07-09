import Foundation

@MainActor
final class NotificationsViewModel<Store: AppStoring>: ViewModelBase {
  enum Filter: String, CaseIterable, Identifiable {
    case all = "すべて"
    case like = "いいね"
    case comment = "コメント"
    case admin = "運営"
    case follow = "フォロー"

    var id: String { rawValue }
  }

  private let store: Store
  @Published var selectedFilter: Filter = .all

  init(store: Store) {
    self.store = store
    super.init()
    observe(store)
  }

  var filteredNotifications: [AppNotification] {
    switch selectedFilter {
    case .all: store.notifications
    case .like: store.notifications.filter { $0.type == .like }
    case .comment: store.notifications.filter { $0.type == .comment }
    case .admin: store.notifications.filter { $0.type == .admin || $0.type == .system }
    case .follow: store.notifications.filter { $0.type == .follow }
    }
  }
}
