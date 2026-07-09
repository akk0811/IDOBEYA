import Combine
import Foundation

/// データ層の抽象インターフェース。
/// 現在は `MockAppStore`、将来は Firebase 実装に差し替え可能。
@MainActor
protocol AppStoring: AnyObject, ObservableObject {
  var isAuthenticated: Bool { get set }
  var currentUser: AppUser { get set }
  var rooms: [AppRoom] { get }
  var posts: [AppPost] { get }
  var comments: [AppComment] { get }
  var notifications: [AppNotification] { get }

  var joinedRooms: [AppRoom] { get }
  var recommendedRooms: [AppRoom] { get }
  var popularRooms: [AppRoom] { get }
  var recentRooms: [AppRoom] { get }
  var unreadNotificationCount: Int { get }

  func login(email: String, password: String)
  func signUp(email: String, password: String, displayName: String)
  func logout()
  func room(id: UUID) -> AppRoom?
  func posts(for roomID: UUID) -> [AppPost]
  func comments(for postID: UUID) -> [AppComment]
  func posts(by userID: UUID) -> [AppPost]
  func markRoomViewed(_ roomID: UUID)
  func toggleLike(postID: UUID)
  func addComment(postID: UUID, body: String)
  func addPost(roomID: UUID, body: String, isAnonymous: Bool, hasImage: Bool, pollQuestion: String?)
  func createRoom(name: String, description: String, category: String, visibility: RoomVisibility, tags: [String])
  func filteredRooms(query: String, category: String?, tag: String?) -> [AppRoom]
}
