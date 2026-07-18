import SwiftUI

// MARK: - Settings Screen

/// Design System v1.0 ベースの設定画面（STEP10）
///
/// Profile から遷移。単体確認時は Preview / DeveloperMenu で下部タブを表示できます。
struct SettingsViewV2: View {
  @Environment(\.dismiss) private var dismiss

  let profile: ProfileUserItem
  let sections: [SettingsSectionItem]
  let showBottomTabBar: Bool

  @State private var toggleStates: [SettingsToggleID: Bool]
  @State private var selectedBottomTab = BottomTabBar.Tab.profile
  @State private var selectedLegalDocument: LegalDocumentRoute?

  init(
    profile: ProfileUserItem = MockProfileUsers.akiko,
    sections: [SettingsSectionItem] = MockSettings.sections,
    previewToggleStates: [SettingsToggleID: Bool]? = nil,
    showBottomTabBar: Bool = true
  ) {
    self.profile = profile
    self.sections = sections
    self.showBottomTabBar = showBottomTabBar
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
        onLeadingTap: { dismiss() },
        onTrailingTap: {}
      )

      ScrollView {
        VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
          accountCard

          ForEach(sections) { section in
            SettingsSectionView(
              section: section,
              toggleStates: $toggleStates,
              onRowTap: handleRowTap
            )

            if section.id == "notifications", areAllNotificationsDisabled {
              notificationOffNote
            }
          }
        }
        .padding(.horizontal, AppTheme.spacing.lg)
        .padding(.top, AppTheme.spacing.sm)
        .padding(.bottom, AppTheme.spacing.xxl)
      }

      if showBottomTabBar {
        BottomTabBar(selection: $selectedBottomTab)
      }
    }
    .background(AppTheme.colors.background)
    .toolbar(.hidden, for: .navigationBar)
    .navigationDestination(item: $selectedLegalDocument) { route in
      route.destination
    }
  }

  // MARK: - Account Card

  private var areAllNotificationsDisabled: Bool {
    SettingsToggleID.allCases.allSatisfy {
      toggleStates[$0, default: true] == false
    }
  }

  private var notificationOffNote: some View {
    Text("通知はあとからいつでも変更できます")
      .font(AppTheme.typography.presets.caption.font())
      .foregroundStyle(AppTheme.colors.textSecondary)
      .padding(.horizontal, AppTheme.spacing.md)
      .accessibilityLabel("通知はあとからいつでも変更できます")
  }

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

  private func handleRowTap(_ row: SettingsRowItem) {
    switch row.id {
    case "support-terms":
      selectedLegalDocument = .terms
    case "support-privacy-policy":
      selectedLegalDocument = .privacy
    default:
      break
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

#Preview("Settings V2 — Dark") {
  SettingsViewV2()
    .preferredColorScheme(.dark)
}

#Preview("Settings V2 — Large Text") {
  SettingsViewV2()
    .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}
