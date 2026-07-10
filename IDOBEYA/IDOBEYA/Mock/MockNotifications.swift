import Foundation

enum NotificationType: Hashable {
  case like
  case comment
  case room
  case system
}

enum NotificationFilter: String, CaseIterable, Identifiable, Hashable {
  case all = "すべて"
  case like = "いいね"
  case comment = "コメント"
  case room = "部屋"
  case system = "運営"

  var id: String { rawValue }

  func matches(_ type: NotificationType) -> Bool {
    switch self {
    case .all: true
    case .like: type == .like
    case .comment: type == .comment
    case .room: type == .room
    case .system: type == .system
    }
  }
}

/// 通知画面の表示用ダミーデータ
struct NotificationItem: Identifiable, Hashable {
  let id: UUID
  let type: NotificationType
  let title: String
  let body: String?
  let createdAt: Date
  let isRead: Bool
}

enum MockNotifications {
  static let all: [NotificationItem] = [
    NotificationItem(
      id: UUID(uuidString: "N1000000-0000-0000-0000-000000000001")!,
      type: .like,
      title: "みどりさんがあなたの投稿にいいねしました",
      body: nil,
      createdAt: Date().addingTimeInterval(-120),
      isRead: false
    ),
    NotificationItem(
      id: UUID(uuidString: "N2000000-0000-0000-0000-000000000002")!,
      type: .comment,
      title: "はるとさんがあなたの投稿にコメントしました",
      body: "「それ分かります。私も同じです」",
      createdAt: Date().addingTimeInterval(-600),
      isRead: false
    ),
    NotificationItem(
      id: UUID(uuidString: "N3000000-0000-0000-0000-000000000003")!,
      type: .room,
      title: "「旅行好き集合」の部屋で新しい投稿があります",
      body: nil,
      createdAt: Date().addingTimeInterval(-1800),
      isRead: true
    ),
    NotificationItem(
      id: UUID(uuidString: "N4000000-0000-0000-0000-000000000004")!,
      type: .system,
      title: "IDOBEYA運営からのお知らせがあります",
      body: "安心して使えるためのガイドラインを更新しました。",
      createdAt: Date().addingTimeInterval(-3600),
      isRead: true
    ),
    NotificationItem(
      id: UUID(uuidString: "N5000000-0000-0000-0000-000000000005")!,
      type: .like,
      title: "さくらさんがあなたの投稿にいいねしました",
      body: nil,
      createdAt: Date().addingTimeInterval(-7200),
      isRead: true
    ),
    NotificationItem(
      id: UUID(uuidString: "N6000000-0000-0000-0000-000000000006")!,
      type: .comment,
      title: "あきこさんがあなたの投稿にコメントしました",
      body: "「ゆっくり休める場所があるのは大事ですよね」",
      createdAt: Date().addingTimeInterval(-10800),
      isRead: true
    ),
    NotificationItem(
      id: UUID(uuidString: "N7000000-0000-0000-0000-000000000007")!,
      type: .room,
      title: "「ゆる雑談の部屋」で新しい投稿があります",
      body: nil,
      createdAt: Date().addingTimeInterval(-14400),
      isRead: true
    ),
  ]

  static func filtered(by category: NotificationFilter, from notifications: [NotificationItem] = all) -> [NotificationItem] {
    notifications.filter { category.matches($0.type) }
  }
}

extension NotificationType {
  var systemImageName: String {
    switch self {
    case .like: "heart.fill"
    case .comment: "bubble.left.fill"
    case .room: "door.left.hand.open"
    case .system: "megaphone.fill"
    }
  }

  var iconTintKey: NotificationIconTint {
    switch self {
    case .like: .accent
    case .comment: .primary
    case .room: .primary
    case .system: .secondary
    }
  }
}

enum NotificationIconTint {
  case primary
  case accent
  case secondary
}
