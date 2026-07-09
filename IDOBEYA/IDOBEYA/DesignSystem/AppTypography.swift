import SwiftUI

/// IDOBEYA Design System — Typography
///
/// フォントサイズ・太さ・行間はここで一元管理します。
/// TypeScript `theme/typography.ts` と同一のトークン名・数値です。
enum AppTypography {

  // MARK: - Font Sizes (pt, TS の px と 1:1)

  enum sizes {
    /// ブランド・ヒーロー見出し（28）
    static let display: CGFloat = 28

    /// 画面タイトル・大見出し（20）
    static let title: CGFloat = 20

    /// セクション見出し（17）
    static let heading: CGFloat = 17

    /// サブ見出し・カードタイトル（15）
    static let subHeading: CGFloat = 15

    /// 本文・ボタンラベル（14）
    static let body: CGFloat = 14

    /// 補足・メタ情報（12）
    static let caption: CGFloat = 12

    /// バッジ・極小ラベル（10）
    static let tiny: CGFloat = 10
  }

  // MARK: - Font Weights

  enum weights {
    static let regularValue = 400
    static let mediumValue = 500
    static let semiboldValue = 600
    static let boldValue = 700

    static var regular: Font.Weight { .regular }
    static var medium: Font.Weight { .medium }
    static var semibold: Font.Weight { .semibold }
    static var bold: Font.Weight { .bold }
  }

  // MARK: - Line Heights

  enum lineHeights {
    static let display: CGFloat = 36
    static let title: CGFloat = 28
    static let heading: CGFloat = 24
    static let subHeading: CGFloat = 22
    static let body: CGFloat = 20
    static let caption: CGFloat = 16
    static let tiny: CGFloat = 14
  }

  // MARK: - Presets

  struct Preset {
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let lineHeight: CGFloat

    func font() -> Font {
      .system(size: fontSize, weight: fontWeight)
    }
  }

  enum presets {
    static let display = Preset(
      fontSize: sizes.display,
      fontWeight: weights.bold,
      lineHeight: lineHeights.display
    )

    static let title = Preset(
      fontSize: sizes.title,
      fontWeight: weights.bold,
      lineHeight: lineHeights.title
    )

    static let heading = Preset(
      fontSize: sizes.heading,
      fontWeight: weights.semibold,
      lineHeight: lineHeights.heading
    )

    static let subHeading = Preset(
      fontSize: sizes.subHeading,
      fontWeight: weights.semibold,
      lineHeight: lineHeights.subHeading
    )

    static let body = Preset(
      fontSize: sizes.body,
      fontWeight: weights.regular,
      lineHeight: lineHeights.body
    )

    static let caption = Preset(
      fontSize: sizes.caption,
      fontWeight: weights.regular,
      lineHeight: lineHeights.caption
    )

    static let tiny = Preset(
      fontSize: sizes.tiny,
      fontWeight: weights.medium,
      lineHeight: lineHeights.tiny
    )
  }
}
