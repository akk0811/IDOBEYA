import SwiftUI

struct CreateRoomVisibilitySection: View {
  @Binding var visibility: RoomVisibility

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
      Text("公開設定")
        .font(IDOFont.body(.medium))
        .foregroundStyle(Theme.Color.textSecondary)

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
      HStack(spacing: Theme.Spacing.sm + 2) {
        Image(systemName: icon)
          .font(.title3)
          .foregroundStyle(visibility == option ? Theme.Color.primary : Theme.Color.textSecondary)
          .frame(width: Theme.Spacing.xl + Theme.Spacing.xs)
        VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
          Text(title)
            .font(IDOFont.body(.semibold))
            .foregroundStyle(Theme.Color.text)
          Text(subtitle)
            .font(IDOFont.caption())
            .foregroundStyle(Theme.Color.textSecondary)
        }
        Spacer()
        Image(systemName: visibility == option ? "checkmark.circle.fill" : "circle")
          .foregroundStyle(visibility == option ? Theme.Color.primary : Theme.Color.border)
      }
      .padding(Theme.Spacing.md)
      .idoCard()
      .overlay(
        RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
          .stroke(visibility == option ? Theme.Color.primary.opacity(0.4) : Theme.Color.background.opacity(0), lineWidth: 1.5)
      )
    }
    .buttonStyle(IDOPressButtonStyle())
  }
}
