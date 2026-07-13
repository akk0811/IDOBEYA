import SwiftUI

/// Design System v1.0 ベースの部屋検索画面（STEP5）
///
/// STEP13 より `MainTabView` の検索タブで使用。Preview 単体確認時は `showBottomTabBar: true`（既定）。
struct SearchViewV2: View {
  let rooms: [SearchRoomItem]
  let recommendedTags: [String]
  let showBottomTabBar: Bool

  @State private var searchText: String
  @State private var selectedCategory: SearchRoomFilter = .all
  @State private var selectedTag: String?
  @State private var selectedTab = BottomTabBar.Tab.search

  init(
    rooms: [SearchRoomItem] = MockSearchRooms.all,
    recommendedTags: [String] = MockSearchRooms.recommendedTags,
    previewSearchText: String? = nil,
    showBottomTabBar: Bool = true
  ) {
    self.rooms = rooms
    self.recommendedTags = recommendedTags
    self.showBottomTabBar = showBottomTabBar
    _searchText = State(initialValue: previewSearchText ?? "")
  }

  private var filteredRooms: [SearchRoomItem] {
    rooms.filtered(query: searchText, category: selectedCategory, tag: selectedTag)
  }

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
          searchHeader
          AppSearchBar(
            placeholder: "キーワードで部屋を検索",
            text: $searchText
          )
          categorySection
          recommendedTagsSection
          roomListSection
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
  }

  // MARK: - Header

  private var searchHeader: some View {
    HStack(alignment: .top, spacing: AppTheme.spacing.sm) {
      VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
        Text("部屋を探す")
          .font(AppTheme.typography.presets.title.font())
          .foregroundStyle(AppTheme.colors.textPrimary)
        Text("気になるテーマの部屋に入ってみましょう")
          .font(AppTheme.typography.presets.body.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
          .fixedSize(horizontal: false, vertical: true)
      }
      Spacer(minLength: AppTheme.spacing.xs)
      IconCircleButton(
        systemName: "plus.circle",
        accessibilityLabel: "部屋を作成",
        action: {}
      )
    }
    .accessibilityElement(children: .combine)
    .accessibilityAddTraits(.isHeader)
  }

  // MARK: - Categories

  private var categorySection: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: AppTheme.spacing.xs) {
        ForEach(SearchRoomFilter.allCases) { filter in
          AppChip(
            title: filter.rawValue,
            isSelected: selectedCategory == filter,
            action: { selectedCategory = filter }
          )
        }
      }
      .padding(.vertical, AppTheme.spacing.xxs)
    }
    .accessibilityLabel("カテゴリー")
  }

  // MARK: - Tags

  private var recommendedTagsSection: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      Text("おすすめタグ")
        .font(AppTheme.typography.presets.heading.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .accessibilityAddTraits(.isHeader)

      FlowLayout(spacing: AppTheme.spacing.xs) {
        ForEach(recommendedTags, id: \.self) { tag in
          AppChip(
            title: tag,
            isSelected: selectedTag == tag,
            action: {
              selectedTag = selectedTag == tag ? nil : tag
            }
          )
        }
      }
    }
  }

  // MARK: - Room List

  private var roomListSection: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      HStack {
        Text("部屋一覧")
          .font(AppTheme.typography.presets.heading.font())
          .foregroundStyle(AppTheme.colors.textPrimary)
          .accessibilityAddTraits(.isHeader)
        Spacer()
        Text("\(filteredRooms.count)件")
          .font(AppTheme.typography.presets.caption.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
      }

      if filteredRooms.isEmpty {
        EmptyStateView(
          iconName: "magnifyingglass",
          title: "該当する部屋が見つかりませんでした",
          message: "キーワードやカテゴリーを変えて探してみましょう"
        )
        .padding(.top, AppTheme.spacing.md)
      } else {
        VStack(spacing: AppTheme.spacing.sm) {
          ForEach(filteredRooms) { room in
            RoomCard(
              iconName: room.iconName,
              name: room.name,
              description: room.description,
              memberCount: room.memberCount,
              badges: roomBadges(room.badges),
              onTap: {}
            )
          }
        }
      }
    }
  }

  // MARK: - Helpers

  private func roomBadges(_ badges: [HomeRoomBadge]) -> [AppBadge.Variant] {
    badges.map {
      switch $0 {
      case .new: .new
      case .hot: .hot
      case .joined: .joined
      }
    }
  }
}

#Preview("Search V2") {
  SearchViewV2()
}

#Preview("Search V2 — No Results") {
  SearchViewV2(previewSearchText: "存在しないキーワード")
}
