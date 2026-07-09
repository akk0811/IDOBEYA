import CoreGraphics

/// IDOBEYA Design System — Radius
///
/// 角丸は定義済みトークンのみ使用してください。
/// TypeScript `theme/radius.ts` と同一のトークン名・数値です。
enum AppRadius {

  /// 8px — チップ・小さなバッジ・入力欄の内側要素
  static let small: CGFloat = 8

  /// 12px — 画像プレースホルダー・ポール選択肢
  static let medium: CGFloat = 12

  /// 16px — カード・リストアイテム（IDOBEYA 標準）
  static let large: CGFloat = 16

  /// 20px — 大きなカード・モーダル上部
  static let xl: CGFloat = 20

  /// 完全なピル型 — ボタン・タグ・フローティングバー
  static let full: CGFloat = 9999
}
