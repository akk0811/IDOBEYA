import SwiftUI

struct CreateRoomVisibilitySection: View {
  @Binding var visibility: RoomVisibility

  var body: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      Text("公開設定")
        .font(AppFont.body(.medium))
        .foregroundStyle(AppTheme.colors.textSecondary)

      visibilityOption(
        option: .public,
        icon: "globe",
        title: "公開",
        subtitle: "誰でも見つけて参加できます"
      )
      visibilityOption(
        option: .inviteOnly,
        icon: "envelope",
        title: "招待制",
        subtitle: "招待コードを知っている人だけ参加できます"
      )
      visibilityOption(
        option: .private,
        icon: "lock",
        title: "非公開",
        subtitle: "作成者が招待したメンバーのみ"
      )
    }
  }

  private func visibilityOption(
    option: RoomVisibility,
    icon: String,
    title: String,
    subtitle: String
  ) -> some View {
    Button { visibility = option } label: {
      HStack(spacing: AppTheme.spacing.sm + AppTheme.spacing.xxs) {
        Image(systemName: icon)
          .font(.title3)
          .foregroundStyle(visibility == option ? AppTheme.colors.primary : AppTheme.colors.textSecondary)
          .frame(width: AppTheme.spacing.xl + AppTheme.spacing.xs)
        VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
          Text(title)
            .font(AppFont.body(.semibold))
            .foregroundStyle(AppTheme.colors.textPrimary)
          Text(subtitle)
            .font(AppFont.caption())
            .foregroundStyle(AppTheme.colors.textSecondary)
        }
        Spacer()
        Image(systemName: visibility == option ? "checkmark.circle.fill" : "circle")
          .foregroundStyle(visibility == option ? AppTheme.colors.primary : AppTheme.colors.border)
      }
      .padding(AppTheme.spacing.md)
      .idoCard()
      .overlay(
        RoundedRectangle(cornerRadius: AppTheme.radius.large, style: .continuous)
          .stroke(visibility == option ? AppTheme.colors.primary.opacity(0.4) : AppTheme.colors.background.opacity(0), lineWidth: 1.5)
      )
    }
    .buttonStyle(AppButtonPressStyle())
  }
}
