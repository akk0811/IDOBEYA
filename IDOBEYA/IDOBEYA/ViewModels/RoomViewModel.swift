import Foundation

@MainActor
final class RoomViewModel<Store: AppStoring>: ViewModelBase {
  private let store: Store
  let room: AppRoom

  @Published var commentText = ""
  @Published var selectedPostID: UUID?

  init(store: Store, room: AppRoom) {
    self.store = store
    self.room = room
    super.init()
    observe(store)
  }

  var roomPosts: [AppPost] { store.posts(for: room.id) }

  func onAppear() {
    store.markRoomViewed(room.id)
  }

  func toggleLike(postID: UUID) {
    store.toggleLike(postID: postID)
  }

  func togglePostExpansion(_ postID: UUID) {
    selectedPostID = selectedPostID == postID ? nil : postID
  }

  func comments(for postID: UUID) -> [AppComment] {
    store.comments(for: postID)
  }

  func submitComment(postID: UUID) {
    guard TextValidator.isNotEmpty(commentText) else { return }
    store.addComment(postID: postID, body: commentText)
    commentText = ""
  }
}
