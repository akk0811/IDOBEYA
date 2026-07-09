import Foundation

@MainActor
final class LoginViewModel<Store: AppStoring>: ViewModelBase {
  private let store: Store

  @Published var email = ""
  @Published var password = ""
  @Published var isLoading = false

  init(store: Store) {
    self.store = store
    super.init()
    observe(store)
  }

  var canSubmit: Bool {
    !email.isEmpty && TextValidator.isValidPassword(password)
  }

  func submit() {
    isLoading = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
      guard let self else { return }
      store.login(email: email, password: password)
      isLoading = false
    }
  }
}
