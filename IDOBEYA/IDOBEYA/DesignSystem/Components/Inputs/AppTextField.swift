import SwiftUI

struct AppTextField: View {
  let label: String
  let placeholder: String
  @Binding var text: String
  var errorMessage: String?
  var isDisabled: Bool = false

  private var hasError: Bool {
    errorMessage != nil
  }

  var body: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      Text(label)
        .font(AppTheme.typography.presets.caption.font())
        .fontWeight(AppTheme.typography.weights.medium)
        .foregroundStyle(AppTheme.colors.textPrimary)

      TextField(placeholder, text: $text)
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .padding(.horizontal, AppTheme.spacing.md)
        .padding(.vertical, AppTheme.spacing.sm)
        .background(AppTheme.colors.surface)
        .overlay(
          RoundedRectangle(cornerRadius: AppTheme.radius.medium)
            .stroke(borderColor, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.medium))
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1)

      if let errorMessage {
        Text(errorMessage)
          .font(AppTheme.typography.presets.caption.font())
          .foregroundStyle(AppTheme.colors.error)
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel(label)
  }

  private var borderColor: Color {
    if hasError { return AppTheme.colors.error }
    return AppTheme.colors.border
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var email = ""
    @State private var nickname = "あきこ"

    var body: some View {
      VStack(spacing: AppTheme.spacing.lg) {
        AppTextField(label: "メールアドレス", placeholder: "example@email.com", text: $email, errorMessage: "有効なメールアドレスを入力してください")
        AppTextField(label: "ニックネーム", placeholder: "表示名", text: $nickname)
        AppTextField(label: "紹介コード", placeholder: "任意", text: .constant(""), isDisabled: true)
      }
      .padding()
      .background(AppTheme.colors.background)
    }
  }

  return PreviewWrapper()
}
