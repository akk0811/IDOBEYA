import Foundation

/// 部屋詳細画面のコメント用ダミーデータ（将来のスレッド表示向け）
struct RoomCommentItem: Identifiable, Hashable {
  let id: UUID
  let postID: UUID
  let authorName: String
  let body: String
  let createdAt: Date
}

enum MockRoomComments {
  static func comments(for postID: UUID) -> [RoomCommentItem] {
    all.filter { $0.postID == postID }
  }

  private static let post1 = UUID(uuidString: "P1000000-0000-0000-0000-000000000001")!
  private static let post2 = UUID(uuidString: "P2000000-0000-0000-0000-000000000002")!

  static let all: [RoomCommentItem] = [
    RoomCommentItem(
      id: UUID(uuidString: "C1000000-0000-0000-0000-000000000001")!,
      postID: post1,
      authorName: "はると",
      body: "ゆっくり休める場所があるのは本当に大事ですよね。",
      createdAt: Date().addingTimeInterval(-3000)
    ),
    RoomCommentItem(
      id: UUID(uuidString: "C2000000-0000-0000-0000-000000000002")!,
      postID: post1,
      authorName: "あきこ",
      body: "お疲れさまです。無理せず過ごしてください。",
      createdAt: Date().addingTimeInterval(-2800)
    ),
    RoomCommentItem(
      id: UUID(uuidString: "C3000000-0000-0000-0000-000000000003")!,
      postID: post2,
      authorName: "みどり",
      body: "私はお茶を淹れて、好きな音楽を聴くのが落ち着きます。",
      createdAt: Date().addingTimeInterval(-6000)
    ),
  ]
}
