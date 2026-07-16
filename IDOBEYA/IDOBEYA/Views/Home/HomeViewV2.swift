import SwiftUI

/// Design System v1.0 ベースのホーム画面（STEP4）
///
/// STEP12 より `MainTabView` のホームタブで使用。Preview 単体確認時は `showBottomTabBar: true`（既定）。
struct HomeViewV2: View {
  let recommendedRooms: [HomeRoomItem]
  let trendingRooms: [HomeRoomItem]
  let latestPosts: [HomePostItem]
  let showBottomTabBar: Bool

  @State private var selectedTab = BottomTabBar.Tab.home

  private var isEmpty: Bool {
    recommendedRooms.isEmpty && trendingRooms.isEmpty && latestPosts.isEmpty
  }

  init(
    recommendedRooms: [HomeRoomItem] = MockHomeRooms.recommended,
    trendingRooms: [HomeRoomItem] = MockHomeRooms.trending,
    latestPosts: [HomePostItem] = MockHomePosts.latest,
    showBottomTabBar: Bool = true
  ) {
    self.recommendedRooms = recommendedRooms
    self.trendingRooms = trendingRooms
    self.latestPosts = latestPosts
    self.showBottomTabBar = showBottomTabBar
  }

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
          homeHeader

          if isEmpty {
            emptyContent
          } else {
            recommendedSection
            trendingSection
            latestPostsSection
          }
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

  private var homeHeader: some View {
    HStack(alignment: .top, spacing: AppTheme.spacing.sm) {
      VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
        Text(GreetingFormatter.current())
          .font(AppTheme.typography.presets.caption.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
        Text("今日はどの部屋に行きますか？")
          .font(AppTheme.typography.presets.title.font())
          .foregroundStyle(AppTheme.colors.textPrimary)
          .fixedSize(horizontal: false, vertical: true)
      }
      Spacer(minLength: AppTheme.spacing.xs)
      IconCircleButton(
        systemName: "bell",
        accessibilityLabel: "通知",
        action: {}
      )
    }
    .accessibilityElement(children: .combine)
    .accessibilityAddTraits(.isHeader)
  }

  // MARK: - Empty

  private var emptyContent: some View {
    EmptyStateView(
      preset: .noJoinedRooms,
      buttonTitle: "部屋を探す",
      buttonAction: {}
    )
    .padding(.top, AppTheme.spacing.xl)
  }

  private func roomBadges(_ badges: [HomeRoomBadge]) -> [AppBadge.Variant] {
    badges.map {
      switch $0 {
      case .new: .new
      case .hot: .hot
      case .joined: .joined
      }
    }
  }

  // MARK: - Recommended Rooms

  private var recommendedSection: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      sectionTitle("おすすめの部屋")

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: AppTheme.spacing.sm) {
          ForEach(recommendedRooms) { room in
            RoomCard(
              iconName: room.iconName,
              name: room.name,
              description: room.description,
              memberCount: room.memberCount,
              badges: roomBadges(room.badges),
              moodBadges: room.moodBadges,
              activityLabel: room.activityLabel,
              onTap: {}
            )
            .frame(width: AppTheme.spacing.massive * 4 + AppTheme.spacing.lg)
          }
        }
        .padding(.vertical, AppTheme.spacing.xxs)
      }
    }
  }

  // MARK: - Trending Rooms

  private var trendingSection: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      sectionTitle("最近あたたかく動いている部屋")

      VStack(spacing: AppTheme.spacing.sm) {
        ForEach(trendingRooms) { room in
          RoomCard(
            iconName: room.iconName,
            name: room.name,
            description: room.description,
            memberCount: room.memberCount,
            badges: roomBadges(room.badges),
            moodBadges: room.moodBadges,
            activityLabel: room.activityLabel,
            onTap: {}
          )
        }
      }
    }
  }

  // MARK: - Latest Posts

  private var latestPostsSection: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      sectionTitle("新着投稿")

      if latestPosts.isEmpty {
        EmptyStateView(preset: .noPosts)
      } else {
        VStack(spacing: AppTheme.spacing.sm) {
          ForEach(latestPosts) { post in
            PostCard(
              authorName: post.authorName,
              avatarImageURL: post.avatarImageURL,
              createdAt: post.createdAt,
              bodyText: post.bodyText,
              likeCount: post.likeCount,
              commentCount: post.commentCount,
              isLiked: post.isLiked,
              onTap: {}
            )
          }
        }
      }
    }
  }

  // MARK: - Helpers

  private func sectionTitle(_ title: String) -> some View {
    Text(title)
      .font(AppTheme.typography.presets.heading.font())
      .foregroundStyle(AppTheme.colors.textPrimary)
      .accessibilityAddTraits(.isHeader)
  }
}

#Preview("Home V2") {
  HomeViewV2()
}

#Preview("Home V2 — Empty") {
  HomeViewV2(
    recommendedRooms: [],
    trendingRooms: [],
    latestPosts: []
  )
}
