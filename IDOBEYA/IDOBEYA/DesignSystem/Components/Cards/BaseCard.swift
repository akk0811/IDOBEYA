import SwiftUI

struct BaseCard<Content: View>: View {
  var padding: CGFloat = AppTheme.spacing.md
  @ViewBuilder let content: () -> Content

  var body: some View {
    content()
      .padding(padding)
      .background(AppTheme.colors.surface)
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large))
      .overlay(
        RoundedRectangle(cornerRadius: AppTheme.radius.large)
          .stroke(AppTheme.colors.border, lineWidth: 1)
      )
      .appShadow(AppTheme.shadow.small)
  }
}

#Preview {
  BaseCard {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      Text("カードタイトル")
        .font(AppTheme.typography.presets.subHeading.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
      Text("BaseCard は全カードの基本となるコンテナです。")
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
    }
  }
  .padding()
  .background(AppTheme.colors.background)
}
