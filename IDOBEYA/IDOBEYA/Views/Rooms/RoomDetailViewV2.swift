import SwiftUI

/// Design System v1.0 ベースの部屋詳細画面（STEP6）
///
/// 本番導線には未組み込み。`MainTabView` は従来の `RoomView` を使用します。
struct RoomDetailViewV2: View {
  enum Tab: String, CaseIterable, Identifiable {
    case posts = "投稿"
    case members = "メンバー"
    case rules = "ルール"

    var id: String { rawValue }
  }

  let room: RoomDetailItem
  let posts: [RoomPostItem]
  let members: [RoomMemberItem]

  @State private var selectedTab: Tab = .posts
  @State private var isJoined: Bool

  init(
    room: RoomDetailItem = MockRoomDetails.chatLounge,
    posts: [RoomPostItem]? = nil,
    members: [RoomMemberItem]? = nil,
    initialIsJoined: Bool = true
  ) {
    self.room = room
    self.posts = posts ?? MockRoomPosts.posts(for: room.id)
    self.members = members ?? MockRoomUsers.members(for: room.id)
    _isJoined = State(initialValue: initialIsJoined)
  }

  var body: some View {
    VStack(spacing: 0) {
      AppHeader(
        title: room.name,
        leadingIcon: "chevron.left",
        trailingIcon: "ellipsis",
        onLeadingTap: {},
        onTrailingTap: {}
      )

      ScrollView {
        VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
          roomInfoCard
          comfortRulesCard
          tabPicker
          tabContent
        }
        .padding(.horizontal, AppTheme.spacing.lg)
        .padding(.top, AppTheme.spacing.sm)
        .padding(.bottom, AppTheme.spacing.xl)
      }
    }
    .background(AppTheme.colors.background)
    .safeAreaInset(edge: .bottom) {
      bottomBar
    }
  }

  // MARK: - Room Info

  private var roomInfoCard: some View {
    BaseCard {
      VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
        HStack(alignment: .top, spacing: AppTheme.spacing.sm) {
          roomIcon
          VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
            Text(room.name)
              .font(AppTheme.typography.presets.subHeading.font())
              .foregroundStyle(AppTheme.colors.textPrimary)
              .lineLimit(2)
            Text(room.description)
              .font(AppTheme.typography.presets.body.font())
              .foregroundStyle(AppTheme.colors.textSecondary)
              .fixedSize(horizontal: false, vertical: true)
          }
          Spacer(minLength: 0)
        }

        metadataRow

        if !room.badges.isEmpty {
          HStack(spacing: AppTheme.spacing.xxs) {
            ForEach(room.badges, id: \.self) { badge in
              let variant = roomBadge(badge)
              AppBadge(variant: variant, label: variant == .hot ? "会話中" : nil)
            }
          }
        }

        if !room.moodBadges.isEmpty {
          FlowLayout(spacing: AppTheme.spacing.xxs) {
            ForEach(room.moodBadges, id: \.self) { mood in
              RoomMoodBadge(title: mood)
            }
          }
        }

        if let activityLabel = room.activityLabel {
          RoomActivityLabel(text: activityLabel)
        }

        joinAction
      }
    }
  }

  private var roomIcon: some View {
    Image(systemName: room.iconName)
      .font(.system(size: AppTheme.typography.sizes.heading, weight: AppTheme.typography.weights.medium))
      .foregroundStyle(AppTheme.colors.primary)
      .frame(width: AppTheme.spacing.xxl, height: AppTheme.spacing.xxl)
      .background(AppTheme.colors.primary.opacity(0.1))
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.medium))
  }

  private var metadataRow: some View {
    HStack(spacing: AppTheme.spacing.sm) {
      Label {
        Text("\(room.memberCount)人参加中")
          .font(AppTheme.typography.presets.caption.font())
      } icon: {
        Image(systemName: "person.2")
      }
      Text("·")
      Text(visibilityLabel)
        .font(AppTheme.typography.presets.caption.font())
    }
    .foregroundStyle(AppTheme.colors.textSecondary)
    .padding(.top, AppTheme.spacing.xxs)
  }

  private var visibilityLabel: String {
    switch room.visibility {
    case .public: "公開部屋"
    case .inviteOnly: "招待制"
    case .private: "非公開"
    }
  }

  @ViewBuilder
  private var joinAction: some View {
    if isJoined {
      HStack(spacing: AppTheme.spacing.xs) {
        Image(systemName: "checkmark.circle.fill")
          .foregroundStyle(AppTheme.colors.primary)
        Text("参加中")
          .font(AppTheme.typography.presets.body.font())
          .fontWeight(AppTheme.typography.weights.medium)
          .foregroundStyle(AppTheme.colors.primary)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, AppTheme.spacing.sm)
      .background(AppTheme.colors.primary.opacity(0.08))
      .clipShape(Capsule())
      .padding(.top, AppTheme.spacing.xs)
    } else {
      PrimaryButton(title: "この部屋をのぞく") {
        isJoined = true
      }
      .padding(.top, AppTheme.spacing.xs)
    }
  }

  // MARK: - Comfort Rules

  private var comfortRulesCard: some View {
    RoomSafetyNote(
      notes: room.safetyNotes.isEmpty ? room.comfortRules : room.safetyNotes,
      title: "この部屋の安心メモ"
    )
  }

  // MARK: - Tabs

  private var tabPicker: some View {
    HStack(spacing: AppTheme.spacing.xs) {
      ForEach(Tab.allCases) { tab in
        AppChip(
          title: tab.rawValue,
          isSelected: selectedTab == tab,
          action: { selectedTab = tab }
        )
      }
      Spacer(minLength: 0)
    }
    .accessibilityLabel("部屋のタブ")
  }

  @ViewBuilder
  private var tabContent: some View {
    switch selectedTab {
    case .posts:
      postsTab
    case .members:
      membersTab
    case .rules:
      rulesTab
    }
  }

  // MARK: - Posts Tab

  private var postsTab: some View {
    Group {
      if posts.isEmpty {
        EmptyStateView(preset: .noPosts)
      } else {
        VStack(spacing: AppTheme.spacing.sm) {
          ForEach(posts) { post in
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

  // MARK: - Members Tab

  private var membersTab: some View {
    Group {
      if members.isEmpty {
        EmptyStateView(
          iconName: "person.2",
          title: "メンバーがいません",
          message: "この部屋にはまだメンバーがいません。"
        )
      } else {
        VStack(spacing: AppTheme.spacing.sm) {
          ForEach(members) { member in
            memberRow(member)
          }
        }
      }
    }
  }

  private func memberRow(_ member: RoomMemberItem) -> some View {
    BaseCard {
      HStack(alignment: .top, spacing: AppTheme.spacing.sm) {
        UserAvatar(name: member.displayName, size: .md)
        VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
          HStack(spacing: AppTheme.spacing.xs) {
            Text(member.displayName)
              .font(AppTheme.typography.presets.subHeading.font())
              .foregroundStyle(AppTheme.colors.textPrimary)
              .lineLimit(1)
            if let badge = memberBadge(member.role) {
              AppBadge(variant: badge)
            }
          }
          Text(member.bio)
            .font(AppTheme.typography.presets.body.font())
            .foregroundStyle(AppTheme.colors.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        Spacer(minLength: 0)
      }
    }
  }

  // MARK: - Rules Tab

  private var rulesTab: some View {
    BaseCard {
      VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
        Text("部屋のルール")
          .font(AppTheme.typography.presets.subHeading.font())
          .foregroundStyle(AppTheme.colors.textPrimary)

        ForEach(Array(room.rules.enumerated()), id: \.offset) { index, rule in
          HStack(alignment: .top, spacing: AppTheme.spacing.sm) {
            Text("\(index + 1).")
              .font(AppTheme.typography.presets.body.font())
              .fontWeight(AppTheme.typography.weights.semibold)
              .foregroundStyle(AppTheme.colors.primary)
              .frame(width: AppTheme.spacing.lg, alignment: .leading)
            Text(rule)
              .font(AppTheme.typography.presets.body.font())
              .foregroundStyle(AppTheme.colors.textPrimary)
              .fixedSize(horizontal: false, vertical: true)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  // MARK: - Bottom Bar

  @ViewBuilder
  private var bottomBar: some View {
    VStack(spacing: 0) {
      Rectangle()
        .fill(AppTheme.colors.border)
        .frame(height: 1)

      Group {
        if isJoined {
          composePromptButton
        } else {
          PrimaryButton(title: "会話を見てみる") {
            isJoined = true
          }
        }
      }
      .padding(.horizontal, AppTheme.spacing.lg)
      .padding(.vertical, AppTheme.spacing.sm)
      .background(AppTheme.colors.surface)
    }
  }

  private var composePromptButton: some View {
    Button(action: {}) {
      HStack(spacing: AppTheme.spacing.sm) {
        Image(systemName: "square.and.pencil")
          .font(.system(size: AppTheme.typography.sizes.body, weight: AppTheme.typography.weights.medium))
        Text("なにか話してみる")
          .font(AppTheme.typography.presets.body.font())
          .fontWeight(AppTheme.typography.weights.medium)
        Spacer(minLength: 0)
      }
      .foregroundStyle(AppTheme.colors.textSecondary)
      .padding(.horizontal, AppTheme.spacing.md)
      .frame(height: AppTheme.spacing.huge)
      .background(AppTheme.colors.background)
      .clipShape(Capsule())
      .overlay(
        Capsule()
          .stroke(AppTheme.colors.border, lineWidth: 1)
      )
    }
    .buttonStyle(AppButtonPressStyle())
    .accessibilityLabel("なにか話してみる")
  }

  // MARK: - Helpers

  private func roomBadge(_ badge: HomeRoomBadge) -> AppBadge.Variant {
    switch badge {
    case .new: .new
    case .hot: .hot
    case .joined: .joined
    }
  }

  private func memberBadge(_ role: RoomMemberRole) -> AppBadge.Variant? {
    switch role {
    case .admin: .admin
    case .official: .official
    case .member: nil
    }
  }
}

#Preview("Room Detail V2") {
  RoomDetailViewV2()
}

#Preview("Room Detail V2 — Not Joined") {
  RoomDetailViewV2(initialIsJoined: false)
}

#Preview("Room Detail V2 — No Posts") {
  RoomDetailViewV2(posts: [])
}
