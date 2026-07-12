import Foundation

/// ホーム画面の PostCard 表示用ダミーデータ
struct HomePostItem: Identifiable, Hashable {
  let id: UUID
  let authorName: String
  let avatarImageURL: URL?
  let createdAt: Date
  let bodyText: String
  let likeCount: Int
  let commentCount: Int
  let isLiked: Bool
}

enum MockHomePosts {
  static let latest: [HomePostItem] = [
    HomePostItem(
      id: UUID(uuidString: "E1000000-0000-0000-0000-000000000001")!,
      authorName: "みどり",
      avatarImageURL: nil,
      createdAt: Date().addingTimeInterval(-3600),
      bodyText: "今日は雨の午後、窓辺でハーブティーを飲みながら本を読んでいました。静かな時間がとても心地よかったです。",
      likeCount: 24,
      commentCount: 5,
      isLiked: true
    ),
    HomePostItem(
      id: UUID(uuidString: "E2000000-0000-0000-0000-000000000002")!,
      authorName: "はると",
      avatarImageURL: nil,
      createdAt: Date().addingTimeInterval(-7200),
      bodyText: "駅前に新しいパン屋さんができました。クロワッサンがとてもふわふわでおすすめです。",
      likeCount: 31,
      commentCount: 6,
      isLiked: false
    ),
    HomePostItem(
      id: UUID(uuidString: "E3000000-0000-0000-0000-000000000003")!,
      authorName: "さくら",
      avatarImageURL: nil,
      createdAt: Date().addingTimeInterval(-10800),
      bodyText: "最近、寝かしつけに時間がかかって疲れています。同じ経験のある方、どう乗り切りましたか？",
      likeCount: 12,
      commentCount: 14,
      isLiked: false
    ),
  ]
}

// MARK: - Room Detail (STEP6)

/// 部屋詳細画面の投稿表示用ダミーデータ
struct RoomPostItem: Identifiable, Hashable {
  let id: UUID
  let roomID: UUID
  let authorName: String
  let avatarImageURL: URL?
  let createdAt: Date
  let bodyText: String
  let likeCount: Int
  let commentCount: Int
  let isLiked: Bool
}

enum MockRoomPosts {
  static func posts(for roomID: UUID) -> [RoomPostItem] {
    guard roomID == MockRoomDetailIDs.chatLounge else { return [] }
    return chatLoungePosts
  }

  private static let chatLoungePosts: [RoomPostItem] = [
    RoomPostItem(
      id: UUID(uuidString: "P1000000-0000-0000-0000-000000000001")!,
      roomID: MockRoomDetailIDs.chatLounge,
      authorName: "みどり",
      avatarImageURL: nil,
      createdAt: Date().addingTimeInterval(-3600),
      bodyText: "今日は少し疲れたので、ゆるく話せる場所があって安心しました。",
      likeCount: 24,
      commentCount: 6,
      isLiked: true
    ),
    RoomPostItem(
      id: UUID(uuidString: "P2000000-0000-0000-0000-000000000002")!,
      roomID: MockRoomDetailIDs.chatLounge,
      authorName: "はると",
      avatarImageURL: nil,
      createdAt: Date().addingTimeInterval(-7200),
      bodyText: "みなさんのリラックス方法を知りたいです。おすすめがあれば教えてください。",
      likeCount: 18,
      commentCount: 4,
      isLiked: false
    ),
    RoomPostItem(
      id: UUID(uuidString: "P3000000-0000-0000-0000-000000000003")!,
      roomID: MockRoomDetailIDs.chatLounge,
      authorName: "さくら",
      avatarImageURL: nil,
      createdAt: Date().addingTimeInterval(-14400),
      bodyText: "初めて参加しました。よろしくお願いします。",
      likeCount: 9,
      commentCount: 3,
      isLiked: false
    ),
  ]
}

// MARK: - Profile (STEP9)

/// プロフィール画面の投稿表示用ダミーデータ
struct ProfilePostItem: Identifiable, Hashable {
  let id: UUID
  let authorID: UUID
  let roomName: String
  let authorName: String
  let avatarImageURL: URL?
  let createdAt: Date
  let bodyText: String
  let likeCount: Int
  let commentCount: Int
  let isLiked: Bool
}

enum MockProfilePosts {
  static func posts(for userID: UUID) -> [ProfilePostItem] {
    guard userID == MockProfileUserIDs.akiko else { return [] }
    return akikoPosts
  }

  private static let akikoPosts: [ProfilePostItem] = [
    ProfilePostItem(
      id: UUID(uuidString: "PP100000-0000-0000-0000-000000000001")!,
      authorID: MockProfileUserIDs.akiko,
      roomName: "静かな読書の部屋",
      authorName: "あきこ",
      avatarImageURL: nil,
      createdAt: Date().addingTimeInterval(-5400),
      bodyText: "今日は静かな読書の部屋でおすすめの本を教えてもらいました。",
      likeCount: 18,
      commentCount: 4,
      isLiked: false
    ),
    ProfilePostItem(
      id: UUID(uuidString: "PP200000-0000-0000-0000-000000000002")!,
      authorID: MockProfileUserIDs.akiko,
      roomName: "ゆる雑談の部屋",
      authorName: "あきこ",
      avatarImageURL: nil,
      createdAt: Date().addingTimeInterval(-14400),
      bodyText: "カフェで読書している時間がいちばん落ち着きます。",
      likeCount: 12,
      commentCount: 2,
      isLiked: true
    ),
    ProfilePostItem(
      id: UUID(uuidString: "PP300000-0000-0000-0000-000000000003")!,
      authorID: MockProfileUserIDs.akiko,
      roomName: "猫好きお茶会",
      authorName: "あきこ",
      avatarImageURL: nil,
      createdAt: Date().addingTimeInterval(-28800),
      bodyText: "うちの猫が窓辺で日向ぼっこしていました。癒やされます。",
      likeCount: 31,
      commentCount: 7,
      isLiked: false
    ),
  ]
}
