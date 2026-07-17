import SwiftUI

struct MainTabView: View {
  @EnvironmentObject private var store: MockAppStore
  @State private var selectedTab: IDOTab = .home

  var body: some View {
    IDOBottomNavigation(selection: $selectedTab, badgeCount: store.unreadNotificationCount) { tab in
      switch tab {
      case .home:
        NavigationStack {
          HomeViewV2(showBottomTabBar: false)
        }
      case .search:
        NavigationStack {
          SearchViewV2(showBottomTabBar: false)
        }
      case .compose: NavigationStack { CreatePostViewV2(showCancelButton: false) }
      case .notifications:
        NavigationStack {
          NotificationViewV2(showBottomTabBar: false)
        }
      case .profile:
        NavigationStack {
          ProfileViewV2(showBottomTabBar: false)
        }
      }
    }
  }
}
