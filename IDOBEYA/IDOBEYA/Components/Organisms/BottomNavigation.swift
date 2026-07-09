import SwiftUI

enum IDOTab: Int, CaseIterable, Identifiable, Hashable {
  case home
  case search
  case compose
  case notifications
  case profile

  var id: Int { rawValue }

  var title: String {
    switch self {
    case .home: "ホーム"
    case .search: "探す"
    case .compose: "投稿"
    case .notifications: "通知"
    case .profile: "マイページ"
    }
  }

  func icon(isSelected: Bool) -> String {
    switch self {
    case .home: isSelected ? "house.fill" : "house"
    case .search: "magnifyingglass"
    case .compose: "square.and.pencil"
    case .notifications: isSelected ? "bell.fill" : "bell"
    case .profile: isSelected ? "person.fill" : "person"
    }
  }
}

struct IDOBottomNavigation<Content: View>: View {
  @Binding var selection: IDOTab
  var badgeCount: Int = 0
  @ViewBuilder let content: (IDOTab) -> Content

  var body: some View {
    TabView(selection: $selection) {
      ForEach(IDOTab.allCases) { tab in
        content(tab)
          .tabItem {
            Label {
              Text(tab.title)
            } icon: {
              Image(systemName: tab.icon(isSelected: selection == tab))
            }
          }
          .tag(tab)
          .accessibilityLabel(A11y.Tab.label(for: tab, badgeCount: tab == .notifications ? badgeCount : 0))
          .accessibilityHint(A11y.Tab.hint(for: tab))
          .if(tab == .notifications && badgeCount > 0) { view in
            view.badge(badgeCount)
          }
      }
    }
    .tint(Theme.Color.primary)
  }
}

private extension View {
  @ViewBuilder
  func `if`<Transformed: View>(_ condition: Bool, transform: (Self) -> Transformed) -> some View {
    if condition { transform(self) } else { self }
  }
}
