import Foundation

enum RoomMemberRole: Hashable {
  case admin
  case official
  case member
}

/// 部屋詳細画面のメンバー表示用ダミーデータ
struct RoomMemberItem: Identifiable, Hashable {
  let id: UUID
  let displayName: String
  let bio: String
  let role: RoomMemberRole
}

enum MockRoomDetailIDs {
  static let chatLounge = UUID(uuidString: "F1000000-0000-0000-0000-000000000001")!
}

enum MockRoomUsers {
  static func members(for roomID: UUID) -> [RoomMemberItem] {
    guard roomID == MockRoomDetailIDs.chatLounge else { return [] }
    return chatLoungeMembers
  }

  private static let chatLoungeMembers: [RoomMemberItem] = [
    RoomMemberItem(
      id: UUID(uuidString: "U1000000-0000-0000-0000-000000000001")!,
      displayName: "あきこ",
      bio: "部屋の管理者です。気軽に話しかけてください。",
      role: .admin
    ),
    RoomMemberItem(
      id: UUID(uuidString: "U2000000-0000-0000-0000-000000000002")!,
      displayName: "みどり",
      bio: "静かな場所で、ゆっくり話すのが好きです。",
      role: .member
    ),
    RoomMemberItem(
      id: UUID(uuidString: "U3000000-0000-0000-0000-000000000003")!,
      displayName: "はると",
      bio: "地域の井戸端話が好きです。",
      role: .member
    ),
    RoomMemberItem(
      id: UUID(uuidString: "U4000000-0000-0000-0000-000000000004")!,
      displayName: "さくら",
      bio: "子育て奮闘中。同じ境遇の方と繋がりたいです。",
      role: .member
    ),
    RoomMemberItem(
      id: UUID(uuidString: "U5000000-0000-0000-0000-000000000005")!,
      displayName: "IDOBEYA運営",
      bio: "安心して使えるコミュニティづくりをサポートします。",
      role: .official
    ),
  ]
}

// MARK: - Create Post (STEP7)

enum MockCreatePostUser {
  static let defaultDisplayName = "あきこ"
  static let anonymousDisplayName = "匿名さん"
  static let anonymousDescription = "この部屋内では表示名を隠して投稿できます。"
}
