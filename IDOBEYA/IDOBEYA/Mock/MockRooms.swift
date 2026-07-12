import Foundation

enum HomeRoomBadge: String, Hashable, CaseIterable {
  case new
  case hot
  case joined
}

/// ホーム画面の RoomCard 表示用ダミーデータ
struct HomeRoomItem: Identifiable, Hashable {
  let id: UUID
  let iconName: String
  let name: String
  let description: String
  let memberCount: Int
  let badges: [HomeRoomBadge]
}

enum MockHomeRooms {
  static let recommended: [HomeRoomItem] = [
    HomeRoomItem(
      id: UUID(uuidString: "D1000000-0000-0000-0000-000000000001")!,
      iconName: "bubble.left.and.bubble.right",
      name: "ゆる雑談の部屋",
      description: "今日あったことを、のんびり共有する場所。批判より共感を大切に。",
      memberCount: 142,
      badges: []
    ),
    HomeRoomItem(
      id: UUID(uuidString: "D2000000-0000-0000-0000-000000000002")!,
      iconName: "airplane",
      name: "旅行好き集合",
      description: "次の旅先やおすすめスポットを、気軽に語り合いましょう。",
      memberCount: 89,
      badges: [.new]
    ),
    HomeRoomItem(
      id: UUID(uuidString: "D3000000-0000-0000-0000-000000000003")!,
      iconName: "cat",
      name: "猫好きお茶会",
      description: "うちの子の写真や、猫あるあるを共有する温かい部屋です。",
      memberCount: 76,
      badges: []
    ),
    HomeRoomItem(
      id: UUID(uuidString: "D4000000-0000-0000-0000-000000000004")!,
      iconName: "figure.2.and.child.holdinghands",
      name: "子育ての井戸端",
      description: "正解はひとつじゃない。安心して話せる子育てコミュニティ。",
      memberCount: 56,
      badges: [.joined]
    ),
  ]

  static let trending: [HomeRoomItem] = [
    HomeRoomItem(
      id: UUID(uuidString: "D5000000-0000-0000-0000-000000000005")!,
      iconName: "flame",
      name: "今夜の夜ふかし部屋",
      description: "眠れない夜に、そっと寄り添える場所。今週いちばん盛り上がり中。",
      memberCount: 312,
      badges: [.hot]
    ),
    HomeRoomItem(
      id: UUID(uuidString: "D6000000-0000-0000-0000-000000000006")!,
      iconName: "book",
      name: "静かな読書の部屋",
      description: "今読んでいる本の感想や、おすすめをゆっくり交換しましょう。",
      memberCount: 198,
      badges: [.hot, .joined]
    ),
    HomeRoomItem(
      id: UUID(uuidString: "D7000000-0000-0000-0000-000000000007")!,
      iconName: "cup.and.saucer",
      name: "ゆるやかカフェ部屋",
      description: "お茶とお菓子の話で、ほっと一息つける部屋です。",
      memberCount: 167,
      badges: [.hot]
    ),
  ]
}

// MARK: - Search (STEP5)

enum SearchRoomFilter: String, CaseIterable, Identifiable {
  case all = "すべて"
  case popular = "人気"
  case hobby = "趣味"
  case consultation = "相談"
  case lifestyle = "生活"
  case learning = "学び"
  case local = "地域"
  case new = "新着"

  var id: String { rawValue }
}

/// 部屋検索画面の RoomCard 表示用ダミーデータ
struct SearchRoomItem: Identifiable, Hashable {
  let id: UUID
  let iconName: String
  let name: String
  let description: String
  let memberCount: Int
  let badges: [HomeRoomBadge]
  let categories: Set<SearchRoomFilter>
  let tags: [String]
  let createdAt: Date
}

enum MockSearchRooms {
  static let recommendedTags: [String] = [
    "雑談", "旅行", "猫好き", "子育て", "転職", "プログラミング", "読書", "カフェ",
  ]

  static let all: [SearchRoomItem] = [
    SearchRoomItem(
      id: UUID(uuidString: "F1000000-0000-0000-0000-000000000001")!,
      iconName: "bubble.left.and.bubble.right",
      name: "ゆる雑談の部屋",
      description: "気軽に今日のことを話しましょう。批判より共感を大切に。",
      memberCount: 142,
      badges: [.hot],
      categories: [.popular, .hobby, .lifestyle],
      tags: ["雑談", "カフェ"],
      createdAt: Date().addingTimeInterval(-86400 * 30)
    ),
    SearchRoomItem(
      id: UUID(uuidString: "F2000000-0000-0000-0000-000000000002")!,
      iconName: "airplane",
      name: "旅行好き集合",
      description: "旅の思い出や行きたい場所を話そう。写真シェア歓迎。",
      memberCount: 89,
      badges: [.new],
      categories: [.hobby, .new],
      tags: ["旅行"],
      createdAt: Date().addingTimeInterval(-86400 * 2)
    ),
    SearchRoomItem(
      id: UUID(uuidString: "F3000000-0000-0000-0000-000000000003")!,
      iconName: "cat",
      name: "猫好きお茶会",
      description: "猫の写真や日常をゆるく共有。猫好きさん大歓迎。",
      memberCount: 76,
      badges: [],
      categories: [.hobby],
      tags: ["猫好き"],
      createdAt: Date().addingTimeInterval(-86400 * 14)
    ),
    SearchRoomItem(
      id: UUID(uuidString: "F4000000-0000-0000-0000-000000000004")!,
      iconName: "figure.2.and.child.holdinghands",
      name: "子育ての井戸端",
      description: "正解はひとつじゃない。安心して話せる子育てコミュニティ。",
      memberCount: 56,
      badges: [.joined],
      categories: [.consultation, .lifestyle],
      tags: ["子育て"],
      createdAt: Date().addingTimeInterval(-86400 * 21)
    ),
    SearchRoomItem(
      id: UUID(uuidString: "F5000000-0000-0000-0000-000000000005")!,
      iconName: "briefcase",
      name: "転職・キャリア相談",
      description: "仕事の悩みや転職の不安を、経験者と一緒に整理する部屋。",
      memberCount: 94,
      badges: [.hot],
      categories: [.popular, .consultation],
      tags: ["転職"],
      createdAt: Date().addingTimeInterval(-86400 * 10)
    ),
    SearchRoomItem(
      id: UUID(uuidString: "F6000000-0000-0000-0000-000000000006")!,
      iconName: "laptopcomputer",
      name: "プログラミング入門",
      description: "初心者でも安心。小さな一歩を励まし合う学びの部屋。",
      memberCount: 68,
      badges: [.new],
      categories: [.learning, .new],
      tags: ["プログラミング"],
      createdAt: Date().addingTimeInterval(-86400 * 3)
    ),
    SearchRoomItem(
      id: UUID(uuidString: "F7000000-0000-0000-0000-000000000007")!,
      iconName: "book",
      name: "静かな読書の部屋",
      description: "今読んでいる本の感想や、おすすめをゆっくり交換しましょう。",
      memberCount: 198,
      badges: [.hot, .joined],
      categories: [.popular, .learning, .hobby],
      tags: ["読書"],
      createdAt: Date().addingTimeInterval(-86400 * 45)
    ),
    SearchRoomItem(
      id: UUID(uuidString: "F8000000-0000-0000-0000-000000000008")!,
      iconName: "cup.and.saucer",
      name: "ゆるやかカフェ部屋",
      description: "お茶とお菓子の話で、ほっと一息つける部屋です。",
      memberCount: 167,
      badges: [],
      categories: [.lifestyle, .hobby],
      tags: ["カフェ", "雑談"],
      createdAt: Date().addingTimeInterval(-86400 * 18)
    ),
    SearchRoomItem(
      id: UUID(uuidString: "F9000000-0000-0000-0000-000000000009")!,
      iconName: "mappin.and.ellipse",
      name: "地域の井戸端",
      description: "近所のお店や季節の話題。顔見知りのような温かさを。",
      memberCount: 203,
      badges: [.hot],
      categories: [.popular, .local],
      tags: ["雑談"],
      createdAt: Date().addingTimeInterval(-86400 * 60)
    ),
    SearchRoomItem(
      id: UUID(uuidString: "FA000000-0000-0000-0000-00000000000A")!,
      iconName: "graduationcap",
      name: "夜の学び部屋",
      description: "資格勉強や語学学習。励まし合いながら続けましょう。",
      memberCount: 71,
      badges: [],
      categories: [.learning],
      tags: ["プログラミング", "読書"],
      createdAt: Date().addingTimeInterval(-86400 * 7)
    ),
  ]
}

extension Array where Element == SearchRoomItem {
  func filtered(
    query: String,
    category: SearchRoomFilter,
    tag: String?
  ) -> [SearchRoomItem] {
    let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

    return filter { room in
      let matchesQuery: Bool = {
        guard !trimmed.isEmpty else { return true }
        let haystack = ([room.name, room.description] + room.tags)
          .joined(separator: " ")
          .lowercased()
        return haystack.contains(trimmed.lowercased())
      }()

      let matchesCategory: Bool = {
        switch category {
        case .all:
          return true
        case .popular:
          return room.categories.contains(.popular) || room.badges.contains(.hot)
        default:
          return room.categories.contains(category)
        }
      }()

      let matchesTag: Bool = {
        guard let tag else { return true }
        return room.tags.contains(tag)
      }()

      return matchesQuery && matchesCategory && matchesTag
    }
  }
}

// MARK: - Room Detail (STEP6)

enum RoomDetailVisibility: String, Hashable {
  case `public` = "公開"
  case inviteOnly = "招待制"
  case `private` = "非公開"
}

/// 部屋詳細画面の表示用ダミーデータ
struct RoomDetailItem: Identifiable, Hashable {
  let id: UUID
  let iconName: String
  let name: String
  let description: String
  let memberCount: Int
  let visibility: RoomDetailVisibility
  let badges: [HomeRoomBadge]
  let comfortRules: [String]
  let rules: [String]
}

enum MockRoomDetails {
  static let chatLounge = RoomDetailItem(
    id: MockRoomDetailIDs.chatLounge,
    iconName: "cup.and.saucer",
    name: "ゆる雑談の部屋",
    description: "気軽に今日のことを話しましょう。批判より共感を大切に。",
    memberCount: 142,
    visibility: .public,
    badges: [.hot, .joined],
    comfortRules: [
      "相手を否定しない",
      "個人情報を書かない",
      "困ったら通報できます",
    ],
    rules: [
      "誹謗中傷は禁止です",
      "個人情報の投稿は禁止です",
      "宣伝目的の連投は禁止です",
      "違和感があれば通報してください",
    ]
  )

  static func room(for id: UUID) -> RoomDetailItem? {
    switch id {
    case MockRoomDetailIDs.chatLounge:
      return chatLounge
    default:
      return nil
    }
  }
}

// MARK: - Create Post (STEP7)

struct CreatePostHint: Identifiable, Hashable {
  let id: String
  let label: String
  let prompt: String
}

struct CreatePostOption: Identifiable, Hashable {
  let id: String
  let label: String
  let systemImage: String
}

enum MockCreatePost {
  static let maxCharacterCount = 500
  static let helperText = "気軽に投稿してください。あとから削除もできます。"

  static let hints: [CreatePostHint] = [
    CreatePostHint(
      id: "today",
      label: "今日あったこと",
      prompt: "今日あったことを少し話すと、"
    ),
    CreatePostHint(
      id: "ask",
      label: "聞いてみたいこと",
      prompt: "みなさんに聞いてみたいのですが、"
    ),
    CreatePostHint(
      id: "recommend",
      label: "おすすめ",
      prompt: "最近おすすめしたいのは、"
    ),
    CreatePostHint(
      id: "worry",
      label: "悩み",
      prompt: "ちょっと悩んでいることがあって、"
    ),
  ]

  static let options: [CreatePostOption] = [
    CreatePostOption(id: "image", label: "画像", systemImage: "photo"),
    CreatePostOption(id: "poll", label: "アンケート", systemImage: "chart.bar"),
    CreatePostOption(id: "emoji", label: "絵文字", systemImage: "face.smiling"),
    CreatePostOption(id: "more", label: "その他", systemImage: "ellipsis"),
  ]
}

// MARK: - Profile (STEP9)

enum MockProfileRooms {
  static func joinedRooms(for userID: UUID) -> [HomeRoomItem] {
    guard userID == MockProfileUserIDs.akiko else { return [] }
    return akikoJoinedRooms
  }

  private static let akikoJoinedRooms: [HomeRoomItem] = [
    HomeRoomItem(
      id: UUID(uuidString: "D1000000-0000-0000-0000-000000000001")!,
      iconName: "bubble.left.and.bubble.right",
      name: "ゆる雑談の部屋",
      description: "今日あったことを、のんびり共有する場所。批判より共感を大切に。",
      memberCount: 142,
      badges: [.joined]
    ),
    HomeRoomItem(
      id: UUID(uuidString: "D3000000-0000-0000-0000-000000000003")!,
      iconName: "cat",
      name: "猫好きお茶会",
      description: "うちの子の写真や、猫あるあるを共有する温かい部屋です。",
      memberCount: 76,
      badges: [.joined]
    ),
    HomeRoomItem(
      id: UUID(uuidString: "D6000000-0000-0000-0000-000000000006")!,
      iconName: "book",
      name: "静かな読書の部屋",
      description: "今読んでいる本の感想や、おすすめをゆっくり交換しましょう。",
      memberCount: 198,
      badges: [.joined]
    ),
  ]
}
