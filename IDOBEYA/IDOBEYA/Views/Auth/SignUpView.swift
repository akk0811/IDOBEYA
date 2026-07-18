import SwiftUI

struct SignUpView: View {
  @Environment(\.dismiss) private var dismiss

  @ObservedObject private var store: MockAppStore
  @StateObject private var viewModel: SignUpViewModel<MockAppStore>

  init(store: MockAppStore) {
    self.store = store
    _viewModel = StateObject(wrappedValue: SignUpViewModel(store: store))
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
        IDOHeader(style: .page(title: "新規登録", subtitle: "IDOBEYAで、あなたの居場所を見つけましょう"))

        VStack(spacing: Theme.Spacing.sm + 2) {
          IDOInput(placeholder: "表示名", text: $viewModel.displayName)
          IDOInput(placeholder: "メールアドレス", text: $viewModel.email)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
          passwordField
        }

        Toggle(isOn: $viewModel.agreedToTerms) {
          Text("利用規約とプライバシーポリシーに同意します")
            .font(IDOFont.caption())
            .foregroundStyle(Theme.Color.textSecondary)
        }
        .tint(Theme.Color.primary)

        if let errorMessage = viewModel.errorMessage {
          Text(errorMessage)
            .font(IDOFont.caption())
            .foregroundStyle(AppTheme.colors.error)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityLabel(errorMessage)
        }

        IDOButton(
          title: "アカウント作成",
          isLoading: viewModel.isLoading,
          isDisabled: !viewModel.canSubmit,
          action: viewModel.submit
        )

        Button("すでにアカウントをお持ちの方") { dismiss() }
          .font(IDOFont.body(.medium))
          .foregroundStyle(Theme.Color.primary)
          .frame(maxWidth: .infinity)
      }
      .padding(Theme.Spacing.xl)
    }
    .idoScreenBackground()
    .navigationBarTitleDisplayMode(.inline)
  }

  private var passwordField: some View {
    SecureField("パスワード（6文字以上）", text: $viewModel.password)
      .font(IDOFont.body())
      .padding(Theme.Spacing.md)
      .background(Theme.Color.surface)
      .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
          .stroke(Theme.Color.border, lineWidth: 1)
      )
      .textContentType(.newPassword)
  }
}
