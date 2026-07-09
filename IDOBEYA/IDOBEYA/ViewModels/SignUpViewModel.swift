import Foundation

@MainActor
final class SignUpViewModel<Store: AppStoring>: ViewModelBase {
  private let store: Store

  @Published var displayName = ""
  @Published var email = ""
  @Published var password = ""
  @Published var agreedToTerms = false
  @Published var isLoading = false

  init(store: Store) {
    self.store = store
    super.init()
    observe(store)
  }

  var canSubmit: Bool {
    TextValidator.isNotEmpty(displayName)
      && !email.isEmpty
      && TextValidator.isValidPassword(password)
      && agreedToTerms
  }

  func submit() {
    isLoading = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
      guard let self else { return }
      store.signUp(email: email, password: password, displayName: displayName)
      isLoading = false
    }
  }
}
