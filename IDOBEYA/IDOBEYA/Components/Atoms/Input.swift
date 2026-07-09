import SwiftUI

struct IDOInput: View {
  let placeholder: String
  @Binding var text: String

  var body: some View {
    TextField(placeholder, text: $text)
      .font(IDOFont.body())
      .foregroundStyle(Theme.Color.text)
      .padding(Theme.Spacing.md)
      .frame(minHeight: Theme.Spacing.minTapTarget)
      .background(Theme.Color.surface)
      .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
          .stroke(Theme.Color.border, lineWidth: 1)
      )
      .accessibilityLabel(placeholder)
  }
}

typealias IDOTextField = IDOInput
