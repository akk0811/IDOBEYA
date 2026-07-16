import SwiftUI

struct RoomActivityLabel: View {
  let text: String

  var body: some View {
    HStack(spacing: AppTheme.spacing.xxs) {
      Image(systemName: "bubble.left.and.bubble.right")
        .font(.system(size: AppTheme.typography.sizes.caption, weight: AppTheme.typography.weights.medium))
      Text(text)
        .font(AppTheme.typography.presets.caption.font())
        .fontWeight(AppTheme.typography.weights.medium)
    }
    .foregroundStyle(AppTheme.colors.primaryDark)
    .padding(.horizontal, AppTheme.spacing.xs)
    .padding(.vertical, AppTheme.spacing.xxs)
    .background(AppTheme.colors.primary.opacity(0.06))
    .clipShape(Capsule())
    .accessibilityLabel(text)
  }
}

#Preview {
  VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
    RoomActivityLabel(text: "今日も会話中")
    RoomActivityLabel(text: "最近あたたかく動いています")
  }
  .padding()
  .background(AppTheme.colors.background)
}
