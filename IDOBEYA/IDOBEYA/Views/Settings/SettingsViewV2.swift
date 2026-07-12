import SwiftUI

// MARK: - Settings Screen

/// Design System v1.0 ベースの設定画面（STEP10）
///
/// 本番導線には未組み込み。`MainTabView` は従来の `SettingsView` を使用します。
struct SettingsViewV2: View {
  let profile: ProfileUserItem
  let sections: [SettingsSectionItem]

  @State private var toggleStates: [SettingsToggleID: Bool]
  @State private var selectedBottomTab = BottomTabBar.Tab.profile

  init(
    profile: ProfileUserItem = MockProfileUsers.akiko,
    sections: [SettingsSectionItem] = MockSettings.sections,
    previewToggleStates: [SettingsToggleID: Bool]? = nil
  ) {
    self.profile = profile
    self.sections = sections
    _toggleStates = State(initialValue: previewToggleStates ?? MockSettings.defaultToggleStates)
  }

  var body: some View {
    VStack(spacing: 0) {
      AppHeader(
        title: "設定",
        leadingIcon: "chevron.left",
        leadingAccessibilityLabel: "戻る",
        trailingIcon: "questionmark.circle",
        trailingAccessibilityLabel: "ヘルプ",
        onLeadingTap: {},
        onTrailingTap: {}
      )

      ScrollView {
        VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
          accountCard

          ForEach(sections) { section in
            SettingsSectionView(
              section: section,
              toggleStates: $toggleStates,
              onRowTap: { _ in }
            )
          }
        }
        .padding(.horizontal, AppTheme.spacing.lg)
        .padding(.top, AppTheme.spacing.sm)
        .padding(.bottom, AppTheme.spacing.xl)
      }

      BottomTabBar(selection: $selectedBottomTab)
    }
    .background(AppTheme.colors.background)
  }

  // MARK: - Account Card

  private var accountCard: some View {
    BaseCard {
      VStack(alignment: .leading, spacing: AppTheme.spacing.md) {
        HStack(alignment: .top, spacing: AppTheme.spacing.md) {
          UserAvatar(name: profile.displayName, size: .lg)

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

        SecondaryButton(title: "プロフィールを編集", action: {})
      }
    }
  }
}

// MARK: - Previews

#Preview("Settings V2") {
  SettingsViewV2()
}

#Preview("Settings V2 — Notifications Off") {
  SettingsViewV2(
    previewToggleStates: [
      .like: false,
      .comment: false,
      .room: false,
      .system: false,
    ]
  )
}
