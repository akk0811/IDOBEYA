import SwiftUI

/// Design System v1.0 のプレビューカタログ。
/// 本番導線には未組み込み。SwiftUI Preview で各コンポーネントの見た目を確認します。
struct DesignSystemCatalogView: View {
  @State private var searchText = ""
  @State private var fieldText = "あきこ"
  @State private var editorText = ""
  @State private var selectedTab = BottomTabBar.Tab.home
  @State private var selectedChip: CategoryChip.Category = .hobby

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
        catalogTitle
        colorsSection
        typographySection
        buttonsSection
        cardsSection
        inputsSection
        avatarsSection
        badgesSection
        chipsSection
        feedbackSection
        navigationSection
      }
      .padding(AppTheme.spacing.lg)
    }
    .background(AppTheme.colors.background)
  }

  // MARK: - Header

  private var catalogTitle: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      Text("IDOBEYA Design System")
        .font(AppTheme.typography.presets.title.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
      Text("v1.0 Preview Catalog")
        .font(AppTheme.typography.presets.caption.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .accessibilityAddTraits(.isHeader)
  }

  // MARK: - 1. Colors

  private var colorsSection: some View {
    catalogSection(title: "Colors") {
      let items: [(String, Color)] = [
        ("Primary", AppTheme.colors.primary),
        ("Accent", AppTheme.colors.accent),
        ("Background", AppTheme.colors.background),
        ("Surface", AppTheme.colors.surface),
        ("Border", AppTheme.colors.border),
        ("Text", AppTheme.colors.textPrimary),
        ("Success", AppTheme.colors.success),
        ("Warning", AppTheme.colors.warning),
        ("Error", AppTheme.colors.error),
      ]

      LazyVGrid(
        columns: [GridItem(.adaptive(minimum: 96), spacing: AppTheme.spacing.sm)],
        spacing: AppTheme.spacing.sm
      ) {
        ForEach(items, id: \.0) { name, color in
          colorChip(name: name, color: color)
        }
      }
    }
  }

  private func colorChip(name: String, color: Color) -> some View {
    VStack(spacing: AppTheme.spacing.xs) {
      RoundedRectangle(cornerRadius: AppTheme.radius.medium)
        .fill(color)
        .frame(height: AppTheme.spacing.huge)
        .overlay(
          RoundedRectangle(cornerRadius: AppTheme.radius.medium)
            .stroke(AppTheme.colors.border, lineWidth: 1)
        )
      Text(name)
        .font(AppTheme.typography.presets.caption.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
    }
  }

  // MARK: - 2. Typography

  private var typographySection: some View {
    catalogSection(title: "Typography") {
      VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
        typographySample("Display", preset: AppTheme.typography.presets.display, text: "井戸端の会話")
        typographySample("Title", preset: AppTheme.typography.presets.title, text: "夜の読書部屋")
        typographySample("Heading", preset: AppTheme.typography.presets.heading, text: "セクション見出し")
        typographySample("Body", preset: AppTheme.typography.presets.body, text: "本文テキストのサンプルです。")
        typographySample("Caption", preset: AppTheme.typography.presets.caption, text: "補足・メタ情報")
        typographySample("Tiny", preset: AppTheme.typography.presets.tiny, text: "TINY LABEL")
      }
    }
  }

  private func typographySample(_ label: String, preset: AppTypography.Preset, text: String) -> some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
      Text(label)
        .font(AppTheme.typography.presets.caption.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
      Text(text)
        .font(preset.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  // MARK: - 3. Buttons

  private var buttonsSection: some View {
    catalogSection(title: "Buttons") {
      VStack(spacing: AppTheme.spacing.sm) {
        PrimaryButton(title: "投稿する", action: {})
        SecondaryButton(title: "部屋を探す", action: {})
        GhostButton(title: "キャンセル", style: .secondary, action: {})
        DangerButton(title: "部屋から退出する", action: {})
        HStack(spacing: AppTheme.spacing.md) {
          IconCircleButton(systemName: "bell", accessibilityLabel: "通知", action: {})
          IconCircleButton(
            systemName: "chevron.left",
            backgroundStyle: .background,
            accessibilityLabel: "戻る",
            action: {}
          )
          IconCircleButton(systemName: "gearshape", accessibilityLabel: "設定", action: {})
        }
        .frame(maxWidth: .infinity)
      }
    }
  }

  // MARK: - 4. Cards

  private var cardsSection: some View {
    catalogSection(title: "Cards") {
      VStack(spacing: AppTheme.spacing.md) {
        BaseCard {
          Text("BaseCard — 全カードの基本コンテナ")
            .font(AppTheme.typography.presets.body.font())
            .foregroundStyle(AppTheme.colors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        RoomCard(
          iconName: "book",
          name: "夜の読書部屋",
          description: "毎晩30分、好きな本について語り合う部屋です。",
          memberCount: 128,
          badges: [.hot, .joined]
        )

        PostCard(
          authorName: "あきこ",
          avatarImageURL: nil,
          createdAt: Date().addingTimeInterval(-3600),
          bodyText: "今日は新しい読書部屋に参加しました。みなさんのおすすめ本、ぜひ教えてください！",
          likeCount: 24,
          commentCount: 8,
          isLiked: true
        )
      }
    }
  }

  // MARK: - 5. Inputs

  private var inputsSection: some View {
    catalogSection(title: "Inputs") {
      VStack(spacing: AppTheme.spacing.md) {
        AppTextField(
          label: "ニックネーム",
          placeholder: "表示名を入力",
          text: $fieldText
        )
        AppSearchBar(placeholder: "部屋や投稿を検索", text: $searchText)
        AppTextEditor(
          placeholder: "いま話したいことを書いてください",
          text: $editorText,
          maxLength: 500
        )
      }
    }
  }

  // MARK: - 6. Avatars

  private var avatarsSection: some View {
    catalogSection(title: "Avatars") {
      VStack(alignment: .leading, spacing: AppTheme.spacing.md) {
        avatarRow(label: "xs", size: .xs)
        avatarRow(label: "sm", size: .sm)
        avatarRow(label: "md", size: .md)
        avatarRow(label: "lg", size: .lg)
        avatarRow(label: "xl", size: .xl)
      }
    }
  }

  private func avatarRow(label: String, size: UserAvatar.Size) -> some View {
    HStack(spacing: AppTheme.spacing.md) {
      Text(label)
        .font(AppTheme.typography.presets.caption.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
        .frame(width: AppTheme.spacing.lg, alignment: .leading)
      UserAvatar(name: "あきこ", size: size)
      UserAvatar(name: "Tanaka Yuki", size: size)
      Spacer()
    }
  }

  // MARK: - 7. Badges

  private var badgesSection: some View {
    catalogSection(title: "Badges") {
      HStack(spacing: AppTheme.spacing.xs) {
        AppBadge(variant: .new)
        AppBadge(variant: .hot)
        AppBadge(variant: .joined)
        AppBadge(variant: .admin)
        AppBadge(variant: .official)
      }
    }
  }

  // MARK: - 8. Chips

  private var chipsSection: some View {
    catalogSection(title: "Chips") {
      VStack(alignment: .leading, spacing: AppTheme.spacing.md) {
        Text("未選択")
          .font(AppTheme.typography.presets.caption.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
        chipGrid(isSelected: false)

        Text("選択中")
          .font(AppTheme.typography.presets.caption.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
        chipGrid(isSelected: true)
      }
    }
  }

  private func chipGrid(isSelected: Bool) -> some View {
    FlowLayout(spacing: AppTheme.spacing.xs) {
      ForEach(CategoryChip.Category.allCases) { category in
        CategoryChip(
          category: category,
          isSelected: isSelected && category == selectedChip,
          action: { selectedChip = category }
        )
      }
    }
  }

  // MARK: - 9. Feedback

  private var feedbackSection: some View {
    catalogSection(title: "Feedback") {
      VStack(spacing: AppTheme.spacing.md) {
        EmptyStateView(
          preset: .noPosts,
          buttonTitle: "投稿する",
          buttonAction: {}
        )

        LoadingView(message: "読み込み中...")
          .frame(height: AppTheme.spacing.massive * 2)
      }
    }
  }

  // MARK: - 10. Navigation

  private var navigationSection: some View {
    catalogSection(title: "Navigation") {
      VStack(spacing: AppTheme.spacing.md) {
        AppHeader(
          title: "ホーム",
          leadingIcon: "chevron.left",
          trailingIcon: "bell",
          onLeadingTap: {},
          onTrailingTap: {}
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large))

        BottomTabBar(selection: $selectedTab)
      }
    }
  }

  // MARK: - Section Helper

  private struct CatalogSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
      BaseCard {
        VStack(alignment: .leading, spacing: AppTheme.spacing.md) {
          Text(title)
            .font(AppTheme.typography.presets.heading.font())
            .foregroundStyle(AppTheme.colors.textPrimary)
            .accessibilityAddTraits(.isHeader)
          content()
        }
      }
    }
  }

  private func catalogSection<Content: View>(
    title: String,
    @ViewBuilder content: @escaping () -> Content
  ) -> CatalogSection<Content> {
    CatalogSection(title: title, content: content)
  }
}

#Preview("Design System Catalog") {
  DesignSystemCatalogView()
}

#Preview("Design System Catalog — Dark") {
  DesignSystemCatalogView()
    .preferredColorScheme(.dark)
}
