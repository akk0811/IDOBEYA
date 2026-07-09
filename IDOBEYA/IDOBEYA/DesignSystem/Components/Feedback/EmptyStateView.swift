import SwiftUI

struct EmptyStateView: View {
  enum Preset {
    case noPosts
    case noNotifications
    case noSearchResults
    case noJoinedRooms

    var iconName: String {
      switch self {
      case .noPosts: "text.bubble"
      case .noNotifications: "bell.slash"
      case .noSearchResults: "magnifyingglass"
      case .noJoinedRooms: "door.left.hand.open"
      }
    }

    var title: String {
      switch self {
      case .noPosts: "まだ投稿がありません"
      case .noNotifications: "通知はありません"
      case .noSearchResults: "検索結果がありません"
      case .noJoinedRooms: "参加している部屋はありません"
      }
    }

    var message: String {
      switch self {
      case .noPosts: "最初の投稿をして、部屋の会話を始めましょう。"
      case .noNotifications: "いいねやコメントがあると、ここに表示されます。"
      case .noSearchResults: "別のキーワードで探してみてください。"
      case .noJoinedRooms: "気になる部屋を見つけて、参加してみましょう。"
      }
    }
  }

  var iconName: String
  var title: String
  var message: String
  var buttonTitle: String?
  var buttonAction: (() -> Void)?

  init(
    iconName: String,
    title: String,
    message: String,
    buttonTitle: String? = nil,
    buttonAction: (() -> Void)? = nil
  ) {
    self.iconName = iconName
    self.title = title
    self.message = message
    self.buttonTitle = buttonTitle
    self.buttonAction = buttonAction
  }

  init(preset: Preset, buttonTitle: String? = nil, buttonAction: (() -> Void)? = nil) {
    self.iconName = preset.iconName
    self.title = preset.title
    self.message = preset.message
    self.buttonTitle = buttonTitle
    self.buttonAction = buttonAction
  }

  var body: some View {
    VStack(spacing: AppTheme.spacing.md) {
      Image(systemName: iconName)
        .font(.system(size: AppTheme.typography.sizes.display, weight: AppTheme.typography.weights.regular))
        .foregroundStyle(AppTheme.colors.primary.opacity(0.7))
        .padding(.bottom, AppTheme.spacing.xs)

      Text(title)
        .font(AppTheme.typography.presets.heading.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .multilineTextAlignment(.center)

      Text(message)
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
        .multilineTextAlignment(.center)

      if let buttonTitle, let buttonAction {
        PrimaryButton(title: buttonTitle, action: buttonAction)
          .padding(.top, AppTheme.spacing.sm)
          .frame(maxWidth: 280)
      }
    }
    .padding(AppTheme.spacing.xl)
    .frame(maxWidth: .infinity)
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(title)。\(message)")
  }
}

#Preview("Presets") {
  ScrollView {
    VStack(spacing: AppTheme.spacing.xxl) {
      EmptyStateView(preset: .noPosts, buttonTitle: "投稿する", buttonAction: {})
      EmptyStateView(preset: .noNotifications)
      EmptyStateView(preset: .noSearchResults)
      EmptyStateView(preset: .noJoinedRooms, buttonTitle: "部屋を探す", buttonAction: {})
    }
    .padding()
  }
  .background(AppTheme.colors.background)
}
