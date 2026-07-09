import SwiftUI

struct MainTabView: View {
  @EnvironmentObject private var store: MockAppStore
  @State private var selectedTab: IDOTab = .home

  var body: some View {
    IDOBottomNavigation(selection: $selectedTab, badgeCount: store.unreadNotificationCount) { tab in
      switch tab {
      case .home: HomeView(store: store)
      case .search: RoomSearchView(store: store)
      case .compose: NavigationStack { ComposePostView(store: store, embeddedInTab: true) }
      case .notifications: NotificationsView(store: store)
      case .profile: ProfileView(store: store)
      }
    }
  }
}
