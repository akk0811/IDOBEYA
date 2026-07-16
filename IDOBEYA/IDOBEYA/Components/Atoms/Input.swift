import SwiftUI

struct IDOInput: View {
  let placeholder: String
  @Binding var text: String

  var body: some View {
    TextField(placeholder, text: $text)
      .font(AppFont.body())
      .foregroundStyle(AppTheme.colors.textPrimary)
      .padding(AppTheme.spacing.md)
      .frame(minHeight: AppTheme.spacing.minTapTarget)
      .background(AppTheme.colors.surface)
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: AppTheme.radius.large, style: .continuous)
          .stroke(AppTheme.colors.border, lineWidth: 1)
      )
      .accessibilityLabel(placeholder)
  }
}

typealias IDOTextField = IDOInput
