import SwiftUI

struct AppTextEditor: View {
  let placeholder: String
  @Binding var text: String
  var maxLength: Int?
  var isDisabled: Bool = false

  private var characterCount: Int {
    text.count
  }

  private var showsCounter: Bool {
    maxLength != nil
  }

  var body: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      ZStack(alignment: .topLeading) {
        if text.isEmpty {
          Text(placeholder)
            .font(AppTheme.typography.presets.body.font())
            .foregroundStyle(AppTheme.colors.textSecondary)
            .padding(.horizontal, AppTheme.spacing.md)
            .padding(.vertical, AppTheme.spacing.md)
        }

        TextEditor(text: $text)
          .font(AppTheme.typography.presets.body.font())
          .foregroundStyle(AppTheme.colors.textPrimary)
          .scrollContentBackground(.hidden)
          .padding(.horizontal, AppTheme.spacing.sm)
          .padding(.vertical, AppTheme.spacing.xs)
          .frame(minHeight: AppTheme.spacing.massive * 2)
          .disabled(isDisabled)
          .onChange(of: text) { _, newValue in
            guard let maxLength, newValue.count > maxLength else { return }
            text = String(newValue.prefix(maxLength))
          }
      }
      .background(AppTheme.colors.surface)
      .overlay(
        RoundedRectangle(cornerRadius: AppTheme.radius.large)
          .stroke(AppTheme.colors.border, lineWidth: 1)
      )
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large))
      .opacity(isDisabled ? 0.6 : 1)

      if showsCounter {
        HStack {
          Spacer()
          Text(counterText)
            .font(AppTheme.typography.presets.caption.font())
            .foregroundStyle(isOverLimit ? AppTheme.colors.error : AppTheme.colors.textSecondary)
        }
      }
    }
    .accessibilityLabel("投稿本文")
  }

  private var isOverLimit: Bool {
    guard let maxLength else { return false }
    return characterCount > maxLength
  }

  private var counterText: String {
    guard let maxLength else { return "\(characterCount)" }
    return "\(characterCount) / \(maxLength)"
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var draftText = ""

    var body: some View {
      AppTextEditor(
        placeholder: "いま話したいことを書いてください",
        text: $draftText,
        maxLength: 500
      )
      .padding()
      .background(AppTheme.colors.background)
    }
  }

  return PreviewWrapper()
}
