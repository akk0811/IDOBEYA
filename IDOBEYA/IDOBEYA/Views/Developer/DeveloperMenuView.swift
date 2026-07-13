import SwiftUI

// MARK: - Developer Menu

/// V2画面とDesign Systemを本番導線へ組み込む前に確認するための開発メニュー。
///
/// `MainTabView` には未組み込み。Preview または一時的な品質チェック用です。
struct DeveloperMenuView: View {
  private let designSystemItems: [DeveloperMenuItem] = [
    DeveloperMenuItem(iconName: "paintpalette", title: "Design System Catalog", destination: .designSystemCatalog),
  ]

  private let mainScreenItems: [DeveloperMenuItem] = [
    DeveloperMenuItem(iconName: "house", title: "ホーム画面 V2", destination: .homeV2),
    DeveloperMenuItem(iconName: "magnifyingglass", title: "部屋検索画面 V2", destination: .searchV2),
    DeveloperMenuItem(iconName: "door.left.hand.open", title: "部屋詳細画面 V2", destination: .roomDetailV2),
    DeveloperMenuItem(iconName: "square.and.pencil", title: "投稿作成画面 V2", destination: .createPostV2),
    DeveloperMenuItem(iconName: "bell", title: "通知画面 V2", destination: .notificationV2),
    DeveloperMenuItem(iconName: "person", title: "プロフィール画面 V2", destination: .profileV2),
    DeveloperMenuItem(iconName: "gearshape", title: "設定画面 V2", destination: .settingsV2),
  ]

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
          headerSection
          menuSection(title: "Design System", items: designSystemItems)
          menuSection(title: "主要画面", items: mainScreenItems)
        }
        .padding(.horizontal, AppTheme.spacing.lg)
        .padding(.top, AppTheme.spacing.sm)
        .padding(.bottom, AppTheme.spacing.xl)
      }
      .background(AppTheme.colors.background)
      .navigationBarHidden(true)
    }
  }

  // MARK: - Header

  private var headerSection: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      Text("開発メニュー")
        .font(AppTheme.typography.presets.title.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .accessibilityAddTraits(.isHeader)

      Text("V2画面とDesign Systemを確認できます")
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }

  // MARK: - Sections

  private func menuSection(title: String, items: [DeveloperMenuItem]) -> some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      Text(title)
        .font(AppTheme.typography.presets.heading.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .accessibilityAddTraits(.isHeader)

      BaseCard(padding: 0) {
        VStack(spacing: 0) {
          ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
            menuLink(for: item)

            if index < items.count - 1 {
              Divider()
                .overlay(AppTheme.colors.border)
                .padding(.leading, AppTheme.spacing.md + AppTheme.spacing.xl + AppTheme.spacing.sm)
            }
          }
        }
      }
    }
  }

  @ViewBuilder
  private func menuLink(for item: DeveloperMenuItem) -> some View {
    NavigationLink {
      destinationView(for: item.destination)
    } label: {
      DeveloperMenuRow(iconName: item.iconName, title: item.title)
    }
    .buttonStyle(.plain)
  }

  @ViewBuilder
  private func destinationView(for destination: DeveloperMenuDestination) -> some View {
    switch destination {
    case .designSystemCatalog:
      DesignSystemCatalogView()
    case .homeV2:
      HomeViewV2()
    case .searchV2:
      SearchViewV2()
    case .roomDetailV2:
      RoomDetailViewV2()
    case .createPostV2:
      CreatePostViewV2()
    case .notificationV2:
      NotificationViewV2()
    case .profileV2:
      ProfileViewV2()
    case .settingsV2:
      SettingsViewV2()
    }
  }
}

// MARK: - Row

private struct DeveloperMenuRow: View {
  let iconName: String
  let title: String

  var body: some View {
    HStack(spacing: AppTheme.spacing.sm) {
      Image(systemName: iconName)
        .font(.system(size: AppTheme.typography.sizes.body, weight: AppTheme.typography.weights.medium))
        .foregroundStyle(AppTheme.colors.primary)
        .frame(width: AppTheme.spacing.xl, height: AppTheme.spacing.xl)
        .background(AppTheme.colors.primary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))

      Text(title)
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .multilineTextAlignment(.leading)

      Spacer(minLength: AppTheme.spacing.xs)

      Image(systemName: "chevron.right")
        .font(.system(size: AppTheme.typography.sizes.caption, weight: AppTheme.typography.weights.semibold))
        .foregroundStyle(AppTheme.colors.textSecondary)
    }
    .padding(.horizontal, AppTheme.spacing.md)
    .padding(.vertical, AppTheme.spacing.sm)
    .contentShape(Rectangle())
    .accessibilityElement(children: .combine)
    .accessibilityLabel(title)
  }
}

// MARK: - Models

private struct DeveloperMenuItem: Identifiable {
  let id = UUID()
  let iconName: String
  let title: String
  let destination: DeveloperMenuDestination
}

private enum DeveloperMenuDestination {
  case designSystemCatalog
  case homeV2
  case searchV2
  case roomDetailV2
  case createPostV2
  case notificationV2
  case profileV2
  case settingsV2
}

// MARK: - Previews

#Preview("Developer Menu") {
  DeveloperMenuView()
}
