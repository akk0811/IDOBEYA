import SwiftUI
import UIKit

/// IDOBEYA Design System — Colors
///
/// 画面・コンポーネントでは hex を直接書かず、`AppTheme.colors.*` を使用してください。
/// パレット（`Palette`）は内部専用。外部からは semantic colors のみ参照します。
/// Light / Dark の両方で読めるよう、semantic colors は adaptive です。
enum AppColors {

  // MARK: - Semantic Colors

  /// メインブランドカラー。ボタン・リンク・アクティブ状態に使用
  static let primary = adaptive(light: Palette.green500, dark: Palette.green400)

  /// Primary の明るいバリエーション。ホバー・背景ハイライトに使用
  static let primaryLight = adaptive(light: Palette.green400, dark: Palette.green500)

  /// Primary の暗いバリエーション。押下状態・強調テキストに使用
  static let primaryDark = adaptive(light: Palette.green600, dark: Palette.green500)

  /// アクセントカラー。いいね・通知バッジ・注目要素に使用
  static let accent = adaptive(light: Palette.amber500, dark: Palette.amber400)

  /// アプリ全体の背景。温かみのあるオフホワイト / ダークブラウン
  static let background = adaptive(light: Palette.cream50, dark: Palette.darkBackground)

  /// カード・入力欄・モーダルなどの表面色
  static let surface = adaptive(light: Palette.white, dark: Palette.darkSurface)

  /// 区切り線・カード枠・非アクティブ境界に使用
  static let border = adaptive(light: Palette.stone300, dark: Palette.darkBorder)

  /// 本文・見出しなど主要テキスト
  static let textPrimary = adaptive(light: Palette.stone800, dark: Palette.darkText)

  /// 補足説明・プレースホルダー・メタ情報
  static let textSecondary = adaptive(light: Palette.stone500, dark: Palette.darkTextSecondary)

  /// 成功状態（参加完了・保存成功など）
  static let success = adaptive(light: Palette.emerald500, dark: Palette.emerald400)

  /// 注意喚起（未保存の変更など）
  static let warning = adaptive(light: Palette.yellow500, dark: Palette.yellow400)

  /// エラー・削除・危険な操作
  static let error = adaptive(light: Palette.red500, dark: Palette.red400)

  /// 情報・ヒント・運営からのお知らせ
  static let info = adaptive(light: Palette.blue500, dark: Palette.blue400)

  // MARK: - Adaptive Helper

  private static func adaptive(light: Color, dark: Color) -> Color {
    Color(
      uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
      }
    )
  }

  // MARK: - Palette (internal)

  /// @internal デザイントークンの元色。直接参照しないこと
  private enum Palette {
    static let green400 = Color(hex: "7CAD88")
    static let green500 = Color(hex: "5F8D6B")
    static let green600 = Color(hex: "4D7358")
    static let amber500 = Color(hex: "D97706")
    static let amber400 = Color(hex: "F59E0B")
    static let cream50 = Color(hex: "FAF8F5")
    static let white = Color(hex: "FFFFFF")
    static let stone800 = Color(hex: "333333")
    static let stone500 = Color(hex: "777777")
    static let stone300 = Color(hex: "E8E1D8")
    static let red500 = Color(hex: "D9534F")
    static let red400 = Color(hex: "E57373")
    static let blue500 = Color(hex: "3B82F6")
    static let blue400 = Color(hex: "60A5FA")
    static let emerald500 = Color(hex: "10B981")
    static let emerald400 = Color(hex: "34D399")
    static let yellow500 = Color(hex: "EAB308")
    static let yellow400 = Color(hex: "FACC15")

    static let darkBackground = Color(hex: "1C1B19")
    static let darkSurface = Color(hex: "2A2826")
    static let darkBorder = Color(hex: "3D3A36")
    static let darkText = Color(hex: "F5F3F0")
    static let darkTextSecondary = Color(hex: "A8A29E")
  }
}
