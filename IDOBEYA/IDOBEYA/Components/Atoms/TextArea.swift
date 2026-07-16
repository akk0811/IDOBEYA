import SwiftUI

struct IDOTextArea: View {
  let placeholder: String
  @Binding var text: String
  var lineLimit: ClosedRange<Int> = 3...8

  var body: some View {
    TextField(placeholder, text: $text, axis: .vertical)
      .font(AppFont.body())
      .foregroundStyle(AppTheme.colors.textPrimary)
      .lineSpacing(AppTheme.spacing.xxs)
      .lineLimit(lineLimit)
      .padding(AppTheme.spacing.md)
      .background(AppTheme.colors.surface)
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: AppTheme.radius.large, style: .continuous)
          .stroke(AppTheme.colors.border, lineWidth: 1)
      )
  }
}
