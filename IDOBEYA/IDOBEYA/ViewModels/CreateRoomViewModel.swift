import Foundation

@MainActor
final class CreateRoomViewModel<Store: AppStoring>: ViewModelBase {
  private let store: Store

  @Published var name = ""
  @Published var description = ""
  @Published var selectedCategory = RoomCategory.hobby.rawValue
  @Published var visibility: RoomVisibility = .public
  @Published var tagInput = ""
  @Published var tags: [String] = []
  @Published var isCreating = false

  init(store: Store) {
    self.store = store
    super.init()
    observe(store)
  }

  var canCreate: Bool {
    TextValidator.isNotEmpty(name) && TextValidator.isNotEmpty(description)
  }

  func addTag() {
    let tag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !tag.isEmpty, !tags.contains(tag) else { return }
    tags.append(tag)
    tagInput = ""
  }

  func removeTag(_ tag: String) {
    tags.removeAll { $0 == tag }
  }

  func createRoom(onComplete: @escaping () -> Void) {
    isCreating = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      guard let self else { return }
      store.createRoom(
        name: name,
        description: description,
        category: selectedCategory,
        visibility: visibility,
        tags: tags
      )
      isCreating = false
      onComplete()
    }
  }
}
