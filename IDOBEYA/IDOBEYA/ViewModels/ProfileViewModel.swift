import Foundation

@MainActor
final class ProfileViewModel<Store: AppStoring>: ViewModelBase {
  private let store: Store

  init(store: Store) {
    self.store = store
    super.init()
    observe(store)
  }

  var user: AppUser { store.currentUser }
  var joinedRooms: [AppRoom] { store.joinedRooms }
  var userPosts: [AppPost] { store.posts(by: store.currentUser.id) }
  var unreadCount: Int { store.unreadNotificationCount }

  func toggleLike(postID: UUID) {
    store.toggleLike(postID: postID)
  }
}
