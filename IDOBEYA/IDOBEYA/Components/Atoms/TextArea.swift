import SwiftUI

struct IDOTextArea: View {
  let placeholder: String
  @Binding var text: String
  var lineLimit: ClosedRange<Int> = 3...8

  var body: some View {
    TextField(placeholder, text: $text, axis: .vertical)
      .font(IDOFont.body())
      .foregroundStyle(IDOTheme.text)
      .lineSpacing(4)
      .lineLimit(lineLimit)
      .padding(16)
      .background(IDOTheme.card)
      .clipShape(RoundedRectangle(cornerRadius: IDOTheme.cardRadius, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: IDOTheme.cardRadius, style: .continuous)
          .stroke(IDOTheme.border, lineWidth: 1)
      )
  }
}
