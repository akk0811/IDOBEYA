import Foundation

enum MockData {
  static let currentUserID = UUID(uuidString: "A1000000-0000-0000-0000-000000000001")!
  static let users: [AppUser] = [
    AppUser(
      id: currentUserID,
      displayName: "あきこ",
      bio: "静かな場所で、ゆっくり話すのが好きです。",
      avatarSymbol: "leaf.fill",
      joinedRoomIDs: []
    ),
    AppUser(
      id: UUID(uuidString: "A2000000-0000-0000-0000-000000000002")!,
      displayName: "みどり",
      bio: "読書とお茶が日課。",
      avatarSymbol: "cup.and.saucer.fill",
      joinedRoomIDs: []
    ),
    AppUser(
      id: UUID(uuidString: "A3000000-0000-0000-0000-000000000003")!,
      displayName: "はると",
      bio: "地域の井戸端話が好きです。",
      avatarSymbol: "house.fill",
      joinedRoomIDs: []
    ),
    AppUser(
      id: UUID(uuidString: "A4000000-0000-0000-0000-000000000004")!,
      displayName: "さくら",
      bio: "子育て奮闘中。同じ境遇の方と繋がりたいです。",
      avatarSymbol: "heart.fill",
      joinedRoomIDs: []
    ),
  ]

  static let roomIDs = (
    cafe: UUID(uuidString: "B1000000-0000-0000-0000-000000000001")!,
    library: UUID(uuidString: "B2000000-0000-0000-0000-000000000002")!,
    local: UUID(uuidString: "B3000000-0000-0000-0000-000000000003")!,
    parenting: UUID(uuidString: "B4000000-0000-0000-0000-000000000004")!,
    study: UUID(uuidString: "B5000000-0000-0000-0000-000000000005")!,
    health: UUID(uuidString: "B6000000-0000-0000-0000-000000000006")!,
    hobby: UUID(uuidString: "B7000000-0000-0000-0000-000000000007")!,
    work: UUID(uuidString: "B8000000-0000-0000-0000-000000000008")!
  )

  static let rooms: [AppRoom] = [
    AppRoom(
      id: roomIDs.cafe,
      name: "ゆるやかカフェ部屋",
      description: "今日あったことを、のんびり共有する場所。批判より共感を大切に。",
      category: "趣味",
      tags: ["お茶", "雑談", "癒し"],
      visibility: .public,
      memberCount: 128,
      isJoined: true
    ),
    AppRoom(
      id: roomIDs.library,
      name: "静かな読書の部屋",
      description: "今読んでいる本の感想や、おすすめをゆっくり交換しましょう。",
      category: "読書",
      tags: ["本", "小説", "エッセイ"],
      visibility: .public,
      memberCount: 94,
      isJoined: true
    ),
    AppRoom(
      id: roomIDs.local,
      name: "地域の井戸端",
      description: "近所のお店や季節の話題。顔見知りのような温かさを。",
      category: "地域",
      tags: ["地域", "イベント", "お店"],
      visibility: .public,
      memberCount: 203,
      isJoined: false
    ),
    AppRoom(
      id: roomIDs.parenting,
      name: "子育てお悩み相談",
      description: "正解はひとつじゃない。安心して話せる場所です。",
      category: "子育て",
      tags: ["育児", "相談", "共感"],
      visibility: .inviteOnly,
      memberCount: 56,
      isJoined: true
    ),
    AppRoom(
      id: roomIDs.study,
      name: "夜の学び部屋",
      description: "資格勉強や語学学習。励まし合いながら続けましょう。",
      category: "学び",
      tags: ["勉強", "資格", "モチベ"],
      visibility: .public,
      memberCount: 71,
      isJoined: false
    ),
    AppRoom(
      id: roomIDs.health,
      name: "からだとこころ",
      description: "健康やメンタルケアについて、穏やかに語り合う部屋。",
      category: "健康",
      tags: ["健康", "睡眠", "セルフケア"],
      visibility: .public,
      memberCount: 88,
      isJoined: false
    ),
    AppRoom(
      id: roomIDs.hobby,
      name: "手仕事の部屋",
      description: "編み物、料理、DIYなど。作品を見せ合いましょう。",
      category: "趣味",
      tags: ["ハンドメイド", "料理", "作品"],
      visibility: .public,
      memberCount: 62,
      isJoined: false
    ),
    AppRoom(
      id: roomIDs.work,
      name: "仕事の悩み相談室",
      description: "職場のこと、キャリアのこと。匿名でも安心して話せます。",
      category: "仕事",
      tags: ["キャリア", "職場", "相談"],
      visibility: .private,
      memberCount: 34,
      isJoined: false
    ),
  ]

  static let postIDs = (
    p1: UUID(uuidString: "C1000000-0000-0000-0000-000000000001")!,
    p2: UUID(uuidString: "C2000000-0000-0000-0000-000000000002")!,
    p3: UUID(uuidString: "C3000000-0000-0000-0000-000000000003")!,
    p4: UUID(uuidString: "C4000000-0000-0000-0000-000000000004")!,
    p5: UUID(uuidString: "C5000000-0000-0000-0000-000000000005")!
  )

  static let posts: [AppPost] = [
    AppPost(
      id: postIDs.p1,
      roomID: roomIDs.cafe,
      authorID: users[1].id,
      authorName: "みどり",
      roomName: "ゆるやかカフェ部屋",
      body: "今日は雨の午後、窓辺でハーブティーを飲みながら本を読んでいました。静かな時間がとても心地よかったです。",
      imageSymbol: "photo",
      isAnonymous: false,
      likeCount: 24,
      commentCount: 5,
      isLiked: true,
      createdAt: Date().addingTimeInterval(-3600)
    ),
    AppPost(
      id: postIDs.p2,
      roomID: roomIDs.library,
      authorID: users[2].id,
      authorName: "はると",
      roomName: "静かな読書の部屋",
      body: "『夜と霧』を読み終えました。短い一冊ですが、考えさせられる内容でした。おすすめの本があれば教えてください。",
      imageSymbol: nil,
      isAnonymous: false,
      likeCount: 18,
      commentCount: 8,
      isLiked: false,
      createdAt: Date().addingTimeInterval(-7200)
    ),
    AppPost(
      id: postIDs.p3,
      roomID: roomIDs.parenting,
      authorID: users[3].id,
      authorName: "さくら",
      roomName: "子育てお悩み相談",
      body: "最近、寝かしつけに時間がかかって疲れています。同じ経験のある方、どう乗り切りましたか？",
      imageSymbol: nil,
      isAnonymous: true,
      likeCount: 12,
      commentCount: 14,
      isLiked: false,
      createdAt: Date().addingTimeInterval(-10800),
      poll: AppPoll(
        id: UUID(),
        question: "寝かしつけで一番大変なのは？",
        options: [
          AppPollOption(id: UUID(), text: "泣き止まない", voteCount: 8),
          AppPollOption(id: UUID(), text: "何度も起きる", voteCount: 12),
          AppPollOption(id: UUID(), text: "寝るのが遅い", voteCount: 5),
        ]
      )
    ),
    AppPost(
      id: postIDs.p4,
      roomID: roomIDs.local,
      authorID: users[2].id,
      authorName: "はると",
      roomName: "地域の井戸端",
      body: "駅前に新しいパン屋さんができました。クロワッサンがとてもふわふわでおすすめです。",
      imageSymbol: "photo",
      isAnonymous: false,
      likeCount: 31,
      commentCount: 6,
      isLiked: true,
      createdAt: Date().addingTimeInterval(-14400)
    ),
    AppPost(
      id: postIDs.p5,
      roomID: roomIDs.study,
      authorID: currentUserID,
      authorName: "あきこ",
      roomName: "夜の学び部屋",
      body: "英語の勉強を3週間続けられました。小さな達成でも嬉しいです。",
      imageSymbol: nil,
      isAnonymous: false,
      likeCount: 9,
      commentCount: 3,
      isLiked: false,
      createdAt: Date().addingTimeInterval(-18000)
    ),
  ]

  static let comments: [AppComment] = [
    AppComment(
      id: UUID(),
      postID: postIDs.p1,
      authorID: users[2].id,
      authorName: "はると",
      body: "素敵な午後ですね。私も明日はゆっくりしようと思います。",
      createdAt: Date().addingTimeInterval(-3000)
    ),
    AppComment(
      id: UUID(),
      postID: postIDs.p1,
      authorID: currentUserID,
      authorName: "あきこ",
      body: "ハーブティー、何のフレーバーですか？",
      createdAt: Date().addingTimeInterval(-2800)
    ),
    AppComment(
      id: UUID(),
      postID: postIDs.p2,
      authorID: users[1].id,
      authorName: "みどり",
      body: "『羊をめぐる冒険』は静かで読みやすいのでおすすめです。",
      createdAt: Date().addingTimeInterval(-6000)
    ),
    AppComment(
      id: UUID(),
      postID: postIDs.p3,
      authorID: users[0].id,
      authorName: "あきこ",
      body: "お疲れさまです。無理せず、できる範囲で大丈夫ですよ。",
      createdAt: Date().addingTimeInterval(-9000)
    ),
  ]

  static let notifications: [AppNotification] = [
    AppNotification(
      id: UUID(),
      type: .like,
      title: "みどりさんがあなたの投稿にいいねしました",
      body: "「英語の勉強を3週間続けられました…」",
      isRead: false,
      createdAt: Date().addingTimeInterval(-1800)
    ),
    AppNotification(
      id: UUID(),
      type: .comment,
      title: "はるとさんがコメントしました",
      body: "ハーブティー、何のフレーバーですか？",
      isRead: false,
      createdAt: Date().addingTimeInterval(-3600)
    ),
    AppNotification(
      id: UUID(),
      type: .follow,
      title: "さくらさんがあなたをフォローしました",
      body: "",
      isRead: true,
      createdAt: Date().addingTimeInterval(-7200)
    ),
    AppNotification(
      id: UUID(),
      type: .admin,
      title: "運営からのお知らせ",
      body: "IDOBEYAへようこそ。安心して使えるコミュニティを目指しています。",
      isRead: true,
      createdAt: Date().addingTimeInterval(-86400)
    ),
    AppNotification(
      id: UUID(),
      type: .system,
      title: "新しい部屋がおすすめです",
      body: "「静かな読書の部屋」があなたに合いそうです。",
      isRead: true,
      createdAt: Date().addingTimeInterval(-172800)
    ),
  ]

  static let popularTags = ["お茶", "読書", "地域", "子育て", "健康", "雑談", "相談", "勉強"]
  static let recentlyViewedRoomIDs = [roomIDs.cafe, roomIDs.library, roomIDs.parenting]
}
