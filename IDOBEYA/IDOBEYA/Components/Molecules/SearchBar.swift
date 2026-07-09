import SwiftUI

struct IDOSearchBar: View {
  @Binding var text: String
  var placeholder: String = "部屋を検索"

  var body: some View {
    HStack(spacing: Theme.Spacing.sm) {
      Image(systemName: "magnifyingglass")
        .foregroundStyle(Theme.Color.textSecondary)
        .accessibilityHidden(true)
      TextField(placeholder, text: $text)
        .font(IDOFont.body())
        .foregroundStyle(Theme.Color.text)
        .accessibilityLabel("検索")
        .accessibilityHint("部屋名や説明で検索します")
      if !text.isEmpty {
        Button { text = "" } label: {
          Image(systemName: "xmark.circle.fill")
            .foregroundStyle(Theme.Color.textSecondary)
        }
        .buttonStyle(.plain)
        .idoMinTapTarget()
        .accessibilityLabel("検索をクリア")
      }
    }
    .padding(Theme.Spacing.sm + 2)
    .background(Theme.Color.surface)
    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
        .stroke(Theme.Color.border, lineWidth: 1)
    )
  }
}
