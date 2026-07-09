import Foundation

@MainActor
final class ProfileEditViewModel<Store: AppStoring>: ViewModelBase {
  private let store: Store

  @Published var displayName = ""
  @Published var bio = ""

  init(store: Store) {
    self.store = store
    super.init()
    observe(store)
  }

  func load() {
    displayName = store.currentUser.displayName
    bio = store.currentUser.bio
  }

  func save() {
    store.currentUser.displayName = displayName
    store.currentUser.bio = bio
  }
}
