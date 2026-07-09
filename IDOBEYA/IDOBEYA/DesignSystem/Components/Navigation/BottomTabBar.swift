import SwiftUI

struct BottomTabBar: View {
  enum Tab: Int, CaseIterable, Identifiable {
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

    var iconName: String {
      switch self {
      case .home: "house"
      case .search: "magnifyingglass"
      case .compose: "square.and.pencil"
      case .notifications: "bell"
      case .profile: "person"
      }
    }

    var selectedIconName: String {
      switch self {
      case .home: "house.fill"
      case .search: "magnifyingglass"
      case .compose: "square.and.pencil"
      case .notifications: "bell.fill"
      case .profile: "person.fill"
      }
    }
  }

  @Binding var selection: Tab
  var onTabTap: ((Tab) -> Void)?

  var body: some View {
    HStack(spacing: 0) {
      ForEach(Tab.allCases) { tab in
        tabButton(for: tab)
      }
    }
    .padding(.horizontal, AppTheme.spacing.sm)
    .padding(.top, AppTheme.spacing.sm)
    .padding(.bottom, AppTheme.spacing.xs)
    .background(AppTheme.colors.surface)
    .overlay(alignment: .top) {
      Rectangle()
        .fill(AppTheme.colors.border)
        .frame(height: 1)
    }
    .appShadow(AppTheme.shadow.small)
    .accessibilityElement(children: .contain)
    .accessibilityLabel("タブバー")
  }

  private func tabButton(for tab: Tab) -> some View {
    let isSelected = selection == tab

    return Button {
      selection = tab
      onTabTap?(tab)
    } label: {
      VStack(spacing: AppTheme.spacing.xxs) {
        Image(systemName: isSelected ? tab.selectedIconName : tab.iconName)
          .font(.system(size: AppTheme.typography.sizes.body, weight: isSelected ? AppTheme.typography.weights.semibold : AppTheme.typography.weights.regular))
        Text(tab.title)
          .font(AppTheme.typography.presets.tiny.font())
          .fontWeight(isSelected ? AppTheme.typography.weights.semibold : AppTheme.typography.weights.regular)
      }
      .foregroundStyle(isSelected ? AppTheme.colors.primary : AppTheme.colors.textSecondary)
      .frame(maxWidth: .infinity)
      .padding(.vertical, AppTheme.spacing.xxs)
    }
    .buttonStyle(.plain)
    .accessibilityLabel(tab.title)
    .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var selection = BottomTabBar.Tab.home

    var body: some View {
      VStack {
        Spacer()
        Text("選択中: \(selection.title)")
          .font(AppTheme.typography.presets.body.font())
        Spacer()
        BottomTabBar(selection: $selection)
      }
      .background(AppTheme.colors.background)
    }
  }

  return PreviewWrapper()
}
