import CoreGraphics

/// IDOBEYA Design System — Spacing
///
/// 許可された余白スケールのみ使用可能です。
/// `padding: 17` などの自由な値は禁止。必ず `AppTheme.spacing.*` を使用してください。
/// TypeScript `theme/spacing.ts` と同一のトークン名・数値です。
enum AppSpacing {

  /// 許可された余白値の一覧
  static let scale: [CGFloat] = [4, 8, 12, 16, 20, 24, 32, 40, 48, 64]

  /// 4px — アイコンとテキストの最小間隔
  static let xxs: CGFloat = 4

  /// 8px — コンパクトな要素間
  static let xs: CGFloat = 8

  /// 12px — チップ内・小さなグループ
  static let sm: CGFloat = 12

  /// 16px — カード内パディング・標準間隔（基本単位）
  static let md: CGFloat = 16

  /// 20px — セクション内・画面横パディング
  static let lg: CGFloat = 20

  /// 24px — セクション間
  static let xl: CGFloat = 24

  /// 32px — 大きなセクション区切り
  static let xxl: CGFloat = 32

  /// 40px — 空状態・ヒーロー余白
  static let xxxl: CGFloat = 40

  /// 48px — 画面上下の余白
  static let huge: CGFloat = 48

  /// 64px — 特大スペーサー
  static let massive: CGFloat = 64

  /// 20px — 画面横パディング（`lg` のエイリアス）
  static let screen: CGFloat = lg

  /// 24px — 片手操作向け下部余白（`xl` のエイリアス）
  static let thumbClearance: CGFloat = xl

  /// 44pt — HIG 最小タップ領域
  static let minTapTarget: CGFloat = 44
}
