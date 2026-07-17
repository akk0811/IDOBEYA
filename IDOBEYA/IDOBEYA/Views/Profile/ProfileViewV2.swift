import SwiftUI

// MARK: - Profile Screen

/// Design System v1.0 ベースのプロフィール画面（STEP9）
///
/// STEP16 より `MainTabView` のプロフィールタブで使用。単体確認時は下部タブを表示します。
struct ProfileViewV2: View {
  enum Tab: String, CaseIterable, Identifiable {
    case posts = "投稿"
    case rooms = "参加部屋"
    case profile = "プロフィール"

    var id: String { rawValue }
  }

  let profile: ProfileUserItem
  let posts: [ProfilePostItem]
  let joinedRooms: [HomeRoomItem]
  let showBottomTabBar: Bool

  @State private var selectedTab: Tab = .posts
  @State private var selectedBottomTab = BottomTabBar.Tab.profile
  @State private var isShowingSettings = false

  init(
    profile: ProfileUserItem = MockProfileUsers.akiko,
    posts: [ProfilePostItem]? = nil,
    joinedRooms: [HomeRoomItem]? = nil,
    showBottomTabBar: Bool = true
  ) {
    self.profile = profile
    self.posts = posts ?? MockProfilePosts.posts(for: profile.id)
    self.joinedRooms = joinedRooms ?? MockProfileRooms.joinedRooms(for: profile.id)
    self.showBottomTabBar = showBottomTabBar
  }

  var body: some View {
    VStack(spacing: 0) {
      AppHeader(
        title: "プロフィール",
        trailingIcon: "gearshape",
        trailingAccessibilityLabel: "設定",
        onTrailingTap: { isShowingSettings = true }
      )

      ScrollView {
        VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
          profileHeaderCard
          comfortNoteCard
          activitySummary
          tabPicker
          tabContent
        }
        .padding(.horizontal, AppTheme.spacing.lg)
        .padding(.top, AppTheme.spacing.sm)
        .padding(.bottom, AppTheme.spacing.xl)
      }

      if showBottomTabBar {
        BottomTabBar(selection: $selectedBottomTab)
      }
    }
    .background(AppTheme.colors.background)
    .navigationDestination(isPresented: $isShowingSettings) {
      SettingsViewV2(
        profile: profile,
        showBottomTabBar: false
      )
    }
    .toolbar(.hidden, for: .navigationBar)
  }

  // MARK: - Profile Header

  private var profileHeaderCard: some View {
    BaseCard {
      VStack(alignment: .leading, spacing: AppTheme.spacing.md) {
        HStack(alignment: .top, spacing: AppTheme.spacing.md) {
          UserAvatar(name: profile.displayName, size: .xl)

          VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
            Text(profile.displayName)
              .font(AppTheme.typography.presets.title.font())
              .foregroundStyle(AppTheme.colors.textPrimary)

            Text("@\(profile.userCode)")
              .font(AppTheme.typography.presets.caption.font())
              .foregroundStyle(AppTheme.colors.textSecondary)
          }

          Spacer(minLength: 0)
        }

        Text(profile.bio)
          .font(AppTheme.typography.presets.body.font())
          .foregroundStyle(AppTheme.colors.textPrimary)
          .fixedSize(horizontal: false, vertical: true)

        profileBadges

        SecondaryButton(title: "プロフィールを編集", action: {})
      }
    }
  }

  private var profileBadges: some View {
    HStack(spacing: AppTheme.spacing.xs) {
      AppBadge(variant: .joined)

      ForEach(profile.interestTags, id: \.self) { tag in
        AppBadge(variant: .joined, label: tag)
      }
    }
  }

  // MARK: - Comfort Note

  private var comfortNoteCard: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      Text("安心メモ")
        .font(AppTheme.typography.presets.subHeading.font())
        .foregroundStyle(AppTheme.colors.textPrimary)

      Text(comfortNoteText)
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(AppTheme.spacing.md)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(AppTheme.colors.primary.opacity(0.06))
    .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.medium))
    .overlay(
      RoundedRectangle(cornerRadius: AppTheme.radius.medium)
        .stroke(AppTheme.colors.primary.opacity(0.12), lineWidth: 1)
    )
  }

  private var comfortNoteText: String {
    "最近は「\(profile.recentActiveRoomName)」で、ゆっくり会話に参加しています。"
  }

  // MARK: - Activity Summary

  private var activitySummary: some View {
    HStack(spacing: AppTheme.spacing.md) {
      summaryItem(title: "参加部屋", value: profile.joinedRoomCount)
      summaryItem(title: "投稿", value: profile.postCount)
      summaryItem(title: "いいね", value: profile.likeCount)
    }
    .padding(AppTheme.spacing.md)
    .background(AppTheme.colors.surface)
    .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large))
    .overlay(
      RoundedRectangle(cornerRadius: AppTheme.radius.large)
        .stroke(AppTheme.colors.border, lineWidth: 1)
    )
  }

  private func summaryItem(title: String, value: Int) -> some View {
    VStack(spacing: AppTheme.spacing.xxs) {
      Text(title)
        .font(AppTheme.typography.presets.caption.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
      Text("\(value)")
        .font(AppTheme.typography.presets.subHeading.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
    }
    .frame(maxWidth: .infinity)
  }

  // MARK: - Tabs

  private var tabPicker: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: AppTheme.spacing.xs) {
        ForEach(Tab.allCases) { tab in
          AppChip(
            title: tab.rawValue,
            isSelected: selectedTab == tab,
            action: { selectedTab = tab }
          )
        }
      }
      .padding(.vertical, AppTheme.spacing.xxs)
    }
    .accessibilityLabel("プロフィールタブ")
  }

  @ViewBuilder
  private var tabContent: some View {
    switch selectedTab {
    case .posts:
      postsTab
    case .rooms:
      roomsTab
    case .profile:
      profileDetailTab
    }
  }

  // MARK: - Posts Tab

  private var postsTab: some View {
    Group {
      if posts.isEmpty {
        EmptyStateView(
          iconName: "text.bubble",
          title: "まだ投稿がありません",
          message: "投稿するとここに表示されます"
        )
        .padding(.top, AppTheme.spacing.lg)
      } else {
        VStack(spacing: AppTheme.spacing.sm) {
          ForEach(posts) { post in
            profilePostCard(post)
          }
        }
      }
    }
  }

  private func profilePostCard(_ post: ProfilePostItem) -> some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      HStack(spacing: AppTheme.spacing.xxs) {
        Image(systemName: "door.left.hand.open")
          .font(.system(size: AppTheme.typography.sizes.caption))
        Text(post.roomName)
          .font(AppTheme.typography.presets.caption.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
      }

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

  // MARK: - Rooms Tab

  private var roomsTab: some View {
    Group {
      if joinedRooms.isEmpty {
        EmptyStateView(
          iconName: "door.left.hand.open",
          title: "参加している部屋はありません",
          message: "気になる部屋を探してみましょう"
        )
        .padding(.top, AppTheme.spacing.lg)
      } else {
        VStack(spacing: AppTheme.spacing.sm) {
          ForEach(joinedRooms) { room in
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
  }

  // MARK: - Profile Detail Tab

  private var profileDetailTab: some View {
    BaseCard {
      VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
        profileDetailSection(
          title: "自己紹介",
          content: profile.bio
        )

        profileDetailListSection(
          title: "好きなテーマ",
          items: profile.favoriteThemes
        )

        profileDetailListSection(
          title: "よくいる部屋",
          items: profile.frequentRoomNames
        )
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  private func profileDetailSection(title: String, content: String) -> some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      sectionTitle(title)
      Text(content)
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }

  private func profileDetailListSection(title: String, items: [String]) -> some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      sectionTitle(title)

      if items.isEmpty {
        Text("まだ登録されていません")
          .font(AppTheme.typography.presets.body.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
      } else if title == "好きなテーマ" {
        Text(items.joined(separator: " / "))
          .font(AppTheme.typography.presets.body.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
          .fixedSize(horizontal: false, vertical: true)
      } else {
        VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
          ForEach(items, id: \.self) { item in
            Text(item)
              .font(AppTheme.typography.presets.body.font())
              .foregroundStyle(AppTheme.colors.textSecondary)
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

// MARK: - Previews

#Preview("Profile V2") {
  ProfileViewV2()
}

#Preview("Profile V2 — No Posts") {
  ProfileViewV2(posts: [])
}

#Preview("Profile V2 — No Joined Rooms") {
  ProfileViewV2(joinedRooms: [])
}
