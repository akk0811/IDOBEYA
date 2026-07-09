import Foundation

struct AppUser: Identifiable, Hashable {
  let id: UUID
  var displayName: String
  var bio: String
  var avatarSymbol: String
  var joinedRoomIDs: [UUID]
}

struct AppRoom: Identifiable, Hashable {
  let id: UUID
  var name: String
  var description: String
  var category: String
  var tags: [String]
  var visibility: RoomVisibility
  var memberCount: Int
  var isJoined: Bool
}

struct AppPost: Identifiable, Hashable {
  let id: UUID
  let roomID: UUID
  let authorID: UUID
  var authorName: String
  var roomName: String
  var body: String
  var imageSymbol: String?
  var isAnonymous: Bool
  var likeCount: Int
  var commentCount: Int
  var isLiked: Bool
  let createdAt: Date
  var poll: AppPoll?
}

struct AppPoll: Identifiable, Hashable {
  let id: UUID
  var question: String
  var options: [AppPollOption]
}

struct AppPollOption: Identifiable, Hashable {
  let id: UUID
  var text: String
  var voteCount: Int
}

struct AppComment: Identifiable, Hashable {
  let id: UUID
  let postID: UUID
  let authorID: UUID
  var authorName: String
  var body: String
  let createdAt: Date
}

enum AppNotificationType: String, Hashable, CaseIterable {
  case like
  case comment
  case follow
  case admin
  case system

  var label: String {
    switch self {
    case .like: "いいね"
    case .comment: "コメント"
    case .follow: "フォロー"
    case .admin: "運営"
    case .system: "お知らせ"
    }
  }

  var icon: String {
    switch self {
    case .like: "heart"
    case .comment: "bubble.left"
    case .follow: "person.badge.plus"
    case .admin: "shield"
    case .system: "bell"
    }
  }
}

struct AppNotification: Identifiable, Hashable {
  let id: UUID
  var type: AppNotificationType
  var title: String
  var body: String
  var isRead: Bool
  let createdAt: Date
}

enum RoomCategory: String, CaseIterable, Identifiable {
  case reading = "読書"
  case hobby = "趣味"
  case local = "地域"
  case work = "仕事"
  case health = "健康"
  case parenting = "子育て"
  case study = "学び"

  var id: String { rawValue }

  var icon: String {
    switch self {
    case .reading: "book"
    case .hobby: "paintpalette"
    case .local: "mappin.and.ellipse"
    case .work: "briefcase"
    case .health: "heart.text.square"
    case .parenting: "figure.2.and.child.holdinghands"
    case .study: "graduationcap"
    }
  }
}
