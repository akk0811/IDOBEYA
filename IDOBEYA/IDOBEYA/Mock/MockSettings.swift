import Foundation

enum SettingsToggleID: String, Hashable, CaseIterable, Identifiable {
  case like
  case comment
  case room
  case system

  var id: String { rawValue }
}

enum SettingsRowKind: Hashable {
  case navigation
  case toggle(SettingsToggleID)
  case danger
}

/// 設定画面の行表示用ダミーデータ
struct SettingsRowItem: Identifiable, Hashable {
  let id: String
  let iconName: String
  let title: String
  let subtitle: String?
  let kind: SettingsRowKind
}

/// 設定画面のセクション表示用ダミーデータ
struct SettingsSectionItem: Identifiable, Hashable {
  let id: String
  let title: String
  let rows: [SettingsRowItem]
  let comfortNote: String?
}

enum MockSettings {
  static let appVersion = "0.1.0"

  static let safetyComfortNote =
    "困ったときは一人で抱え込まなくて大丈夫です。セーフティガイドや相談先から、安心して使うための情報を確認できます。"

  static let defaultToggleStates: [SettingsToggleID: Bool] = [
    .like: true,
    .comment: true,
    .room: true,
    .system: true,
  ]

  static let sections: [SettingsSectionItem] = [
    SettingsSectionItem(
      id: "account",
      title: "アカウント",
      rows: [
        SettingsRowItem(id: "account-profile", iconName: "person", title: "プロフィール編集", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "account-display-name", iconName: "pencil", title: "表示名の変更", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "account-email", iconName: "envelope", title: "メールアドレス", subtitle: "変更・確認", kind: .navigation),
        SettingsRowItem(id: "account-password", iconName: "key", title: "パスワード変更", subtitle: nil, kind: .navigation),
      ],
      comfortNote: nil
    ),
    SettingsSectionItem(
      id: "notifications",
      title: "通知",
      rows: [
        SettingsRowItem(id: "notify-like", iconName: "heart", title: "いいね通知", subtitle: "投稿へのいいね", kind: .toggle(.like)),
        SettingsRowItem(id: "notify-comment", iconName: "bubble.left", title: "コメント通知", subtitle: "投稿へのコメント", kind: .toggle(.comment)),
        SettingsRowItem(id: "notify-room", iconName: "door.left.hand.open", title: "部屋の新着通知", subtitle: "参加中の部屋の更新", kind: .toggle(.room)),
        SettingsRowItem(id: "notify-system", iconName: "megaphone", title: "運営からのお知らせ", subtitle: "重要なお知らせ", kind: .toggle(.system)),
      ],
      comfortNote: nil
    ),
    SettingsSectionItem(
      id: "privacy",
      title: "プライバシー",
      rows: [
        SettingsRowItem(id: "privacy-hidden-rooms", iconName: "eye.slash", title: "非公開部屋の表示設定", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "privacy-blocked-users", iconName: "person.crop.circle.badge.xmark", title: "ブロックしたユーザー", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "privacy-muted-rooms", iconName: "speaker.slash", title: "ミュートした部屋", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "privacy-visibility", iconName: "lock.shield", title: "アカウントの公開範囲", subtitle: "部屋内のみ公開", kind: .navigation),
      ],
      comfortNote: nil
    ),
    SettingsSectionItem(
      id: "safety",
      title: "安心・安全",
      rows: [
        SettingsRowItem(id: "safety-reports", iconName: "flag", title: "通報履歴", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "safety-guide", iconName: "shield", title: "セーフティガイド", subtitle: "安心して使うためのヒント", kind: .navigation),
        SettingsRowItem(id: "safety-support", iconName: "lifepreserver", title: "困ったときの相談先", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "safety-guidelines", iconName: "doc.text", title: "コミュニティガイドライン", subtitle: nil, kind: .navigation),
      ],
      comfortNote: safetyComfortNote
    ),
    SettingsSectionItem(
      id: "app",
      title: "アプリ",
      rows: [
        SettingsRowItem(id: "app-theme", iconName: "paintbrush", title: "テーマ設定", subtitle: "ライト", kind: .navigation),
        SettingsRowItem(id: "app-font-size", iconName: "textformat.size", title: "文字サイズ", subtitle: "標準", kind: .navigation),
        SettingsRowItem(id: "app-cache", iconName: "trash", title: "キャッシュ削除", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "app-version", iconName: "info.circle", title: "バージョン情報", subtitle: appVersion, kind: .navigation),
      ],
      comfortNote: nil
    ),
    SettingsSectionItem(
      id: "support",
      title: "サポート",
      rows: [
        SettingsRowItem(id: "support-help", iconName: "questionmark.circle", title: "ヘルプ", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "support-contact", iconName: "envelope.open", title: "お問い合わせ", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "support-terms", iconName: "doc.plaintext", title: "利用規約", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "support-privacy-policy", iconName: "hand.raised", title: "プライバシーポリシー", subtitle: nil, kind: .navigation),
      ],
      comfortNote: nil
    ),
    SettingsSectionItem(
      id: "account-actions",
      title: "アカウント操作",
      rows: [
        SettingsRowItem(id: "action-logout", iconName: "rectangle.portrait.and.arrow.right", title: "ログアウト", subtitle: nil, kind: .navigation),
        SettingsRowItem(id: "action-delete", iconName: "trash", title: "アカウント削除", subtitle: "この操作は取り消せません", kind: .danger),
      ],
      comfortNote: nil
    ),
  ]
}
