import SwiftUI

struct IDOCard<Content: View>: View {
  var padding: CGFloat = Theme.Spacing.md
  @ViewBuilder let content: () -> Content

  var body: some View {
    content()
      .padding(padding)
      .idoCard()
  }
}

struct IDOCardModifier: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  func body(content: Content) -> some View {
    content
      .background(Theme.Color.surface)
      .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous))
      .shadow(
        color: Theme.Color.shadow,
        radius: colorScheme == .dark ? 0 : 8,
        x: 0,
        y: colorScheme == .dark ? 0 : 2
      )
      .overlay(
        RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
          .stroke(colorScheme == .dark ? Theme.Color.border.opacity(0.5) : Theme.Color.background.opacity(0), lineWidth: 1)
      )
  }
}

extension View {
  func idoCard() -> some View {
    modifier(IDOCardModifier())
  }
}
