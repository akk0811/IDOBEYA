import SwiftUI

struct LoginView: View {
  @ObservedObject var store: MockAppStore
  @StateObject private var viewModel: LoginViewModel<MockAppStore>

  init(store: MockAppStore) {
    self.store = store
    _viewModel = StateObject(wrappedValue: LoginViewModel(store: store))
  }

  var body: some View {
    ScrollView {
      VStack(spacing: Theme.Spacing.xxl) {
        authHeader
        VStack(spacing: Theme.Spacing.sm + 2) {
          IDOInput(placeholder: "メールアドレス", text: $viewModel.email)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
          passwordField
        }
        IDOButton(
          title: "ログイン",
          isLoading: viewModel.isLoading,
          isDisabled: !viewModel.canSubmit,
          action: viewModel.submit
        )
        NavigationLink { SignUpView(store: store) } label: {
          Text("アカウントをお持ちでない方はこちら")
            .font(IDOFont.body(.medium))
            .foregroundStyle(Theme.Color.primary)
        }
      }
      .padding(Theme.Spacing.xl)
      .padding(.top, Theme.Spacing.xxl + Theme.Spacing.xs)
    }
    .idoScreenBackground()
    .navigationBarHidden(true)
  }

  private var authHeader: some View {
    VStack(spacing: Theme.Spacing.md) {
      Image("LoginIcon")
        .resizable()
        .scaledToFit()
        .frame(width: Theme.IconSize.brand, height: Theme.IconSize.brand)
        .accessibilityLabel("IDOBEYA")
      VStack(spacing: Theme.Spacing.xs) {
        Text(Brand.name)
          .font(IDOFont.brand())
          .foregroundStyle(Theme.Color.text)
        Text(Brand.catchCopy)
          .font(IDOFont.body())
          .foregroundStyle(Theme.Color.textSecondary)
          .multilineTextAlignment(.center)
          .lineSpacing(Theme.Spacing.xxs)
      }
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
      .textContentType(.password)
  }
}
