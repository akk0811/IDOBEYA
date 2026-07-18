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

    let trimmedDisplayName = displayName.trimmingCharacters(
      in: .whitespacesAndNewlines
    )
    let trimmedEmail = email.trimmingCharacters(
      in: .whitespacesAndNewlines
    )

    guard !trimmedDisplayName.isEmpty else {
      errorMessage = "表示名を入力してください"
      return
    }

    guard !trimmedEmail.isEmpty else {
      errorMessage = "メールアドレスを入力してください"
      return
    }

    isLoading = true
    errorMessage = nil

    defer {
      isLoading = false
    }

    store.signUp(
      email: trimmedEmail,
      password: password,
      displayName: trimmedDisplayName
    )
  }
}
