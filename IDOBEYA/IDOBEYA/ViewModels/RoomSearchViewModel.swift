import Foundation

@MainActor
final class RoomSearchViewModel<Store: AppStoring>: ViewModelBase {
  private let store: Store

  @Published var query = ""
  @Published var selectedCategory: String?
  @Published var selectedTag: String?

  init(store: Store) {
    self.store = store
    super.init()
    observe(store)
  }

  var filteredRooms: [AppRoom] {
    store.filteredRooms(query: query, category: selectedCategory, tag: selectedTag)
  }

  var popularTags: [String] { MockData.popularTags }
}
