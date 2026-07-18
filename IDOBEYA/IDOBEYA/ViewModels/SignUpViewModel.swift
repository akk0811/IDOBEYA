import Foundation

@MainActor
final class SignUpViewModel<Store: AppStoring>: ViewModelBase {
  private let store: Store

  @Published var displayName = ""
  @Published var email = ""
  @Published var password = ""
  @Published var agreedToTerms = false
  @Published var isLoading = false
  @Published var errorMessage: String?

  init(store: Store) {
    self.store = store
    super.init()
    observe(store)
  }

  var canSubmit: Bool {
    TextValidator.isNotEmpty(displayName)
      && TextValidator.isNotEmpty(email)
      && TextValidator.isValidPassword(password)
      && agreedToTerms
  }

  func submit() {
    guard canSubmit, !isLoading else { return }

    if let validationMessage = validateBeforeSubmit() {
      errorMessage = validationMessage
      return
    }

    isLoading = true
    errorMessage = nil

    store.signUp(
      email: email.trimmingCharacters(in: .whitespacesAndNewlines),
      password: password,
      displayName: displayName.trimmingCharacters(in: .whitespacesAndNewlines)
    )

    isLoading = false
  }

  private func validateBeforeSubmit() -> String? {
    let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

    if trimmedName.isEmpty {
      return "表示名を入力してください"
    }

    if trimmedEmail.isEmpty {
      return "メールアドレスを入力してください"
    }

    if !TextValidator.isValidPassword(password) {
      return "パスワードは6文字以上で入力してください"
    }

    if !agreedToTerms {
      return "利用規約とプライバシーポリシーへの同意が必要です"
    }

    return nil
  }
}
