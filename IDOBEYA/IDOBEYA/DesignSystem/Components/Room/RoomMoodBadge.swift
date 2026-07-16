import SwiftUI

struct RoomMoodBadge: View {
  let title: String
  var isSubtle: Bool = false

  var body: some View {
    Text(title)
      .font(AppTheme.typography.presets.tiny.font())
      .fontWeight(AppTheme.typography.weights.medium)
      .foregroundStyle(isSubtle ? AppTheme.colors.textSecondary : AppTheme.colors.primaryDark)
      .padding(.horizontal, AppTheme.spacing.xs)
      .padding(.vertical, AppTheme.spacing.xxs)
      .background(isSubtle ? AppTheme.colors.background : AppTheme.colors.primary.opacity(0.08))
      .overlay(
        Capsule()
          .stroke(isSubtle ? AppTheme.colors.border : AppTheme.colors.primary.opacity(0.12), lineWidth: 1)
      )
      .clipShape(Capsule())
      .accessibilityLabel(title)
  }
}

#Preview {
  FlowLayout(spacing: AppTheme.spacing.xs) {
    RoomMoodBadge(title: "初心者歓迎")
    RoomMoodBadge(title: "見るだけOK")
    RoomMoodBadge(title: "匿名OK", isSubtle: true)
    RoomMoodBadge(title: "ゆっくり会話")
  }
  .padding()
  .background(AppTheme.colors.background)
}
