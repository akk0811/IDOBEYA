import SwiftUI

struct IDOSearchBar: View {
  @Binding var text: String
  var placeholder: String = "部屋を検索"

  var body: some View {
    HStack(spacing: AppTheme.spacing.sm) {
      Image(systemName: "magnifyingglass")
        .foregroundStyle(AppTheme.colors.textSecondary)
        .accessibilityHidden(true)
      TextField(placeholder, text: $text)
        .font(AppFont.body())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .accessibilityLabel("検索")
        .accessibilityHint("部屋名や説明で検索します")
      if !text.isEmpty {
        Button { text = "" } label: {
          Image(systemName: "xmark.circle.fill")
            .foregroundStyle(AppTheme.colors.textSecondary)
        }
        .buttonStyle(.plain)
        .idoMinTapTarget()
        .accessibilityLabel("検索をクリア")
      }
    }
    .padding(AppTheme.spacing.sm + AppTheme.spacing.xxs)
    .background(AppTheme.colors.surface)
    .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: AppTheme.radius.large, style: .continuous)
        .stroke(AppTheme.colors.border, lineWidth: 1)
    )
  }
}
