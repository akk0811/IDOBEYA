import SwiftUI

/// IDOBEYA Design System — Colors
///
/// 画面・コンポーネントでは hex を直接書かず、`AppTheme.colors.*` を使用してください。
/// パレット（`Palette`）は内部専用。外部からは semantic colors のみ参照します。
/// TypeScript `theme/colors.ts` と同一のトークン名・色値です。
enum AppColors {

  // MARK: - Semantic Colors

  /// メインブランドカラー。ボタン・リンク・アクティブ状態に使用
  static let primary = Palette.green500

  /// Primary の明るいバリエーション。ホバー・背景ハイライトに使用
  static let primaryLight = Palette.green400

  /// Primary の暗いバリエーション。押下状態・強調テキストに使用
  static let primaryDark = Palette.green600

  /// アクセントカラー。いいね・通知バッジ・注目要素に使用
  static let accent = Palette.amber500

  /// アプリ全体の背景。温かみのあるオフホワイト
  static let background = Palette.cream50

  /// カード・入力欄・モーダルなどの表面色
  static let surface = Palette.white

  /// 区切り線・カード枠・非アクティブ境界に使用
  static let border = Palette.stone300

  /// 本文・見出しなど主要テキスト
  static let textPrimary = Palette.stone800

  /// 補足説明・プレースホルダー・メタ情報
  static let textSecondary = Palette.stone500

  /// 成功状態（参加完了・保存成功など）
  static let success = Palette.emerald500

  /// 注意喚起（未保存の変更など）
  static let warning = Palette.yellow500

  /// エラー・削除・危険な操作
  static let error = Palette.red500

  /// 情報・ヒント・運営からのお知らせ
  static let info = Palette.blue500

  // MARK: - Palette (internal)

  /// @internal デザイントークンの元色。直接参照しないこと
  private enum Palette {
    static let green400 = Color(hex: "7CAD88")
    static let green500 = Color(hex: "5F8D6B")
    static let green600 = Color(hex: "4D7358")
    static let green700 = Color(hex: "3D5C46")
    static let amber500 = Color(hex: "D97706")
    static let amber400 = Color(hex: "F59E0B")
    static let cream50 = Color(hex: "FAF8F5")
    static let cream100 = Color(hex: "F5F1EB")
    static let white = Color(hex: "FFFFFF")
    static let stone800 = Color(hex: "333333")
    static let stone500 = Color(hex: "777777")
    static let stone300 = Color(hex: "E8E1D8")
    static let stone200 = Color(hex: "F0EBE3")
    static let red500 = Color(hex: "D9534F")
    static let red400 = Color(hex: "E57373")
    static let blue500 = Color(hex: "3B82F6")
    static let blue400 = Color(hex: "60A5FA")
    static let emerald500 = Color(hex: "10B981")
    static let yellow500 = Color(hex: "EAB308")
  }
}
