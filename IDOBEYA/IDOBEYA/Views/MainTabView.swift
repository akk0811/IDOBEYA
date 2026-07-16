import SwiftUI

struct MainTabView: View {
  @EnvironmentObject private var store: MockAppStore
  @State private var selectedTab: IDOTab = .home

  var body: some View {
    IDOBottomNavigation(selection: $selectedTab, badgeCount: store.unreadNotificationCount) { tab in
      switch tab {
      case .home: HomeViewV2(showBottomTabBar: false)
      case .search: SearchViewV2(showBottomTabBar: false)
      case .compose: NavigationStack { CreatePostViewV2(showCancelButton: false) }
      case .notifications: NotificationViewV2(showBottomTabBar: false)
      case .profile: ProfileView(store: store)
      }
    }
  }
}
