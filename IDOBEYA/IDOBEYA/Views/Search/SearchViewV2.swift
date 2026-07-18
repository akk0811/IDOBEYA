import SwiftUI

/// Design System v1.0 ベースの部屋検索画面（STEP5）
///
/// STEP13 より `MainTabView` の検索タブで使用。Preview 単体確認時は `showBottomTabBar: true`（既定）。
struct SearchViewV2: View {
  let rooms: [SearchRoomItem]
  let recommendedTags: [String]
  let moodFilters: [String]
  let showBottomTabBar: Bool

  @State private var searchText: String
  @State private var selectedCategory: SearchRoomFilter = .all
  @State private var selectedTag: String?
  @State private var selectedMood: String?
  @State private var selectedTab = BottomTabBar.Tab.search
  @State private var selectedRoom: RoomDetailItem?

  init(
    rooms: [SearchRoomItem] = MockSearchRooms.all,
    recommendedTags: [String] = MockSearchRooms.recommendedTags,
    moodFilters: [String] = MockSearchRooms.moodFilters,
    previewSearchText: String? = nil,
    showBottomTabBar: Bool = true
  ) {
    self.rooms = rooms
    self.recommendedTags = recommendedTags
    self.moodFilters = moodFilters
    self.showBottomTabBar = showBottomTabBar
    _searchText = State(initialValue: previewSearchText ?? "")
  }

  private var filteredRooms: [SearchRoomItem] {
    rooms.filtered(query: searchText, category: selectedCategory, tag: selectedTag, mood: selectedMood)
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
          moodFilterSection
          roomListSection
        }
        .padding(.horizontal, AppTheme.spacing.lg)
        .padding(.top, AppTheme.spacing.sm)
        .padding(.bottom, AppTheme.spacing.xl)
      }
      .scrollDismissesKeyboard(.interactively)

      if showBottomTabBar {
        BottomTabBar(selection: $selectedTab)
      }
    }
    .background(AppTheme.colors.background)
    .navigationDestination(item: $selectedRoom) { room in
      RoomDetailViewV2(room: room)
    }
    .toolbar {
      ToolbarItemGroup(placement: .keyboard) {
        Spacer()
        Button("完了") {
          UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
          )
        }
      }
    }
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

  private var moodFilterSection: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      Text("雰囲気で探す")
        .font(AppTheme.typography.presets.heading.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .accessibilityAddTraits(.isHeader)

      FlowLayout(spacing: AppTheme.spacing.xs) {
        ForEach(moodFilters, id: \.self) { mood in
          AppChip(
            title: mood,
            systemImage: moodIcon(for: mood),
            isSelected: selectedMood == mood,
            action: {
              selectedMood = selectedMood == mood ? nil : mood
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
          title: "条件に合う部屋が見つかりませんでした",
          message: "検索条件を少し変えてみてください"
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
              moodBadges: room.moodBadges,
              activityLabel: room.activityLabel,
              onTap: { selectedRoom = RoomDetailItem(searchRoom: room) }
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

  private func moodIcon(for mood: String) -> String {
    switch mood {
    case "初心者歓迎":
      return "leaf"
    case "見るだけOK":
      return "eye"
    case "匿名OK":
      return "person.crop.circle.badge.questionmark"
    case "ゆっくり会話":
      return "cup.and.saucer"
    default:
      return "tag"
    }
  }
}

#Preview("Search V2") {
  SearchViewV2()
}

#Preview("Search V2 — No Results") {
  SearchViewV2(previewSearchText: "存在しないキーワード")
}

#Preview("Search V2 — Dark") {
  SearchViewV2()
    .preferredColorScheme(.dark)
}

#Preview("Search V2 — Large Text") {
  SearchViewV2()
    .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}
