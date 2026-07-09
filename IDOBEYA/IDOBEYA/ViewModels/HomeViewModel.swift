import Foundation

@MainActor
final class HomeViewModel<Store: AppStoring>: ViewModelBase {
  private let store: Store

  init(store: Store) {
    self.store = store
    super.init()
    observe(store)
  }

  var greeting: String { GreetingFormatter.current() }
  var userName: String { "\(store.currentUser.displayName)さん" }
  var catchCopy: String { Brand.catchCopy }
  var recommendedRooms: [AppRoom] { store.recommendedRooms }
  var popularRooms: [AppRoom] { store.popularRooms }
  var recentRooms: [AppRoom] { store.recentRooms }
  var latestPosts: [AppPost] { Array(store.posts.prefix(3)) }

  func toggleLike(postID: UUID) {
    store.toggleLike(postID: postID)
  }
}
