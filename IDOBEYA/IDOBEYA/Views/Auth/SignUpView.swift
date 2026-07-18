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

        agreementRow

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
    .onChange(of: store.isAuthenticated) { _, isAuthenticated in
      #if DEBUG
      print("SignUpView authentication changed:", isAuthenticated)
      #endif
      // RootView が MainTabView へ切り替えるため、ここでは dismiss しない
    }
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

  private var agreementRow: some View {
    HStack(alignment: .center, spacing: Theme.Spacing.sm) {
      HStack(spacing: 0) {
        legalLink("利用規約", destination: TermsOfServiceView())
        Text("と")
          .foregroundStyle(Theme.Color.textSecondary)
        legalLink("プライバシーポリシー", destination: PrivacyPolicyView())
        Text("に同意します")
          .foregroundStyle(Theme.Color.textSecondary)
      }
      .font(IDOFont.caption())
      .lineLimit(2)
      .minimumScaleFactor(0.75)

      Spacer(minLength: Theme.Spacing.sm)

      Toggle("", isOn: $viewModel.agreedToTerms)
        .labelsHidden()
        .tint(Theme.Color.primary)
    }
    .accessibilityElement(children: .contain)
  }

  private func legalLink<Destination: View>(_ title: String, destination: Destination) -> some View {
    NavigationLink {
      destination
    } label: {
      Text(title)
        .font(IDOFont.caption(.medium))
        .foregroundStyle(Theme.Color.primary)
        .underline()
    }
    .buttonStyle(.plain)
    .accessibilityLabel(title)
  }
}
