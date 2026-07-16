import SwiftUI

struct IDOCard<Content: View>: View {
  var padding: CGFloat = AppTheme.spacing.md
  @ViewBuilder let content: () -> Content

  var body: some View {
    content()
      .padding(padding)
      .idoCard()
  }
}

struct IDOCardModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(AppTheme.colors.surface)
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: AppTheme.radius.large, style: .continuous)
          .stroke(AppTheme.colors.border, lineWidth: 1)
      )
      .appShadow(AppTheme.shadow.small)
  }
}

extension View {
  func idoCard() -> some View {
    modifier(IDOCardModifier())
  }
}
