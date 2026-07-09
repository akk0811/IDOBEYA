import SwiftUI

/// IDOBEYA Design System — Shadow
///
/// カード・モーダル・BottomSheet で再利用する影トークン。
/// TypeScript `theme/shadow.ts` と同一のトークン名・数値です。
enum AppShadow {

  struct Definition {
    let offsetX: CGFloat
    let offsetY: CGFloat
    let blur: CGFloat
    let spread: CGFloat
    let color: Color
    /// React Native elevation (Android) とのパリティ用
    let elevation: CGFloat
  }

  // MARK: - Shadow Colors (textPrimary から派生)

  private static let shadowColor = AppColors.textPrimary.opacity(10.0 / 255.0)
  private static let shadowColorMedium = AppColors.textPrimary.opacity(20.0 / 255.0)
  private static let shadowColorLarge = AppColors.textPrimary.opacity(31.0 / 255.0)

  /// Small — リストカード・チップ（部屋カード、投稿カード）
  static let small = Definition(
    offsetX: 0,
    offsetY: 1,
    blur: 4,
    spread: 0,
    color: shadowColor,
    elevation: 2
  )

  /// Medium — モーダル・ドロップダウン（通報シート、部屋選択メニュー）
  static let medium = Definition(
    offsetX: 0,
    offsetY: 4,
    blur: 12,
    spread: 0,
    color: shadowColorMedium,
    elevation: 6
  )

  /// Large — BottomSheet・フローティングパネル（投稿オプション、画像ビューア）
  static let large = Definition(
    offsetX: 0,
    offsetY: 8,
    blur: 24,
    spread: 0,
    color: shadowColorLarge,
    elevation: 12
  )
}
