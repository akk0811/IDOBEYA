import Foundation

@MainActor
final class MockAppStore: ObservableObject, AppStoring {
  static let shared = MockAppStore()

  @Published var isAuthenticated = false
  @Published var currentUser: AppUser
  @Published var rooms: [AppRoom]
  @Published var posts: [AppPost]
  @Published var comments: [AppComment]
  @Published var notifications: [AppNotification]
  @Published var recentlyViewedRoomIDs: [UUID]

  private init() {
    currentUser = MockData.users[0]
    rooms = MockData.rooms
    posts = MockData.posts
    comments = MockData.comments
    notifications = MockData.notifications
    recentlyViewedRoomIDs = MockData.recentlyViewedRoomIDs
    currentUser.joinedRoomIDs = rooms.filter(\.isJoined).map(\.id)
  }

  var joinedRooms: [AppRoom] {
    rooms.filter(\.isJoined)
  }

  var recommendedRooms: [AppRoom] {
    rooms.filter { !$0.isJoined && $0.visibility == .public }.prefix(4).map { $0 }
  }

  var popularRooms: [AppRoom] {
    rooms.sorted { $0.memberCount > $1.memberCount }.prefix(4).map { $0 }
  }

  var recentRooms: [AppRoom] {
    recentlyViewedRoomIDs.compactMap { id in rooms.first { $0.id == id } }
  }

  var unreadNotificationCount: Int {
    notifications.filter { !$0.isRead }.count
  }

  func login(email: String, password: String) {
    isAuthenticated = true
  }

  func signUp(email: String, password: String, displayName: String) {
    currentUser.displayName = displayName
    isAuthenticated = true

    #if DEBUG
    print("Mock sign up succeeded")
    print("isAuthenticated:", isAuthenticated)
    #endif
  }

  func logout() {
    isAuthenticated = false
  }

  func room(id: UUID) -> AppRoom? {
    rooms.first { $0.id == id }
  }

  func posts(for roomID: UUID) -> [AppPost] {
    posts.filter { $0.roomID == roomID }.sorted { $0.createdAt > $1.createdAt }
  }

  func comments(for postID: UUID) -> [AppComment] {
    comments.filter { $0.postID == postID }.sorted { $0.createdAt < $1.createdAt }
  }

  func posts(by userID: UUID) -> [AppPost] {
    posts.filter { $0.authorID == userID && !$0.isAnonymous }
      .sorted { $0.createdAt > $1.createdAt }
  }

  func markRoomViewed(_ roomID: UUID) {
    recentlyViewedRoomIDs.removeAll { $0 == roomID }
    recentlyViewedRoomIDs.insert(roomID, at: 0)
    if recentlyViewedRoomIDs.count > 5 {
      recentlyViewedRoomIDs = Array(recentlyViewedRoomIDs.prefix(5))
    }
  }

  func toggleLike(postID: UUID) {
    guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
    posts[index].isLiked.toggle()
    posts[index].likeCount += posts[index].isLiked ? 1 : -1
  }

  func addComment(postID: UUID, body: String) {
    let comment = AppComment(
      id: UUID(),
      postID: postID,
      authorID: currentUser.id,
      authorName: currentUser.displayName,
      body: body,
      createdAt: Date()
    )
    comments.append(comment)
    if let index = posts.firstIndex(where: { $0.id == postID }) {
      posts[index].commentCount += 1
    }
  }

  func addPost(
    roomID: UUID,
    body: String,
    isAnonymous: Bool,
    hasImage: Bool,
    pollQuestion: String?
  ) {
    guard let room = room(id: roomID) else { return }
    let post = AppPost(
      id: UUID(),
      roomID: roomID,
      authorID: currentUser.id,
      authorName: isAnonymous ? "匿名" : currentUser.displayName,
      roomName: room.name,
      body: body,
      imageSymbol: hasImage ? "photo" : nil,
      isAnonymous: isAnonymous,
      likeCount: 0,
      commentCount: 0,
      isLiked: false,
      createdAt: Date(),
      poll: pollQuestion.map { q in
        AppPoll(
          id: UUID(),
          question: q,
          options: [
            AppPollOption(id: UUID(), text: "はい", voteCount: 0),
            AppPollOption(id: UUID(), text: "いいえ", voteCount: 0),
          ]
        )
      }
    )
    posts.insert(post, at: 0)
  }

  func createRoom(
    name: String,
    description: String,
    category: String,
    visibility: RoomVisibility,
    tags: [String]
  ) {
    let room = AppRoom(
      id: UUID(),
      name: name,
      description: description,
      category: category,
      tags: tags,
      visibility: visibility,
      memberCount: 1,
      isJoined: true
    )
    rooms.insert(room, at: 0)
    currentUser.joinedRoomIDs.append(room.id)
  }

  func filteredRooms(query: String, category: String?, tag: String?) -> [AppRoom] {
    rooms.filter { room in
      let matchesQuery = query.isEmpty
        || room.name.localizedCaseInsensitiveContains(query)
        || room.description.localizedCaseInsensitiveContains(query)
      let matchesCategory = category == nil || room.category == category
      let matchesTag = tag == nil || room.tags.contains(tag!)
      return matchesQuery && matchesCategory && matchesTag
    }
  }

  func filteredNotifications(type: AppNotificationType?) -> [AppNotification] {
  guard let type else { return notifications }
  if type == .system {
    return notifications.filter { $0.type == .system }
  }
  return notifications.filter { $0.type == type }
  }
}
