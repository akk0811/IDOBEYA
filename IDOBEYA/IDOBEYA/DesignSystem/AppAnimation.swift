import SwiftUI

/// IDOBEYA Design System — Animation
///
/// アニメーションの duration と easing を一元管理します。
/// TypeScript `theme/animation.ts` と同一のトークン名・数値です。
enum AppAnimation {

  // MARK: - Duration (ミリ秒)

  enum duration {
    /// 150ms — ボタン押下・チップ選択
    static let fast: Double = 150

    /// 250ms — 画面遷移・セクション展開（標準）
    static let normal: Double = 250

    /// 400ms — モーダル表示・大きなレイアウト変化
    static let slow: Double = 400

    /// SwiftUI 用（秒）
    static var fastSeconds: Double { fast / 1000 }
    static var normalSeconds: Double { normal / 1000 }
    static var slowSeconds: Double { slow / 1000 }
  }

  // MARK: - Easing (CSS transition-timing-function 互換の識別子)

  enum ease {
    static let ease = "ease"
    static let easeIn = "ease-in"
    static let easeOut = "ease-out"
    static let easeInOut = "ease-in-out"

    /// SwiftUI `Animation` へのマッピング
    static func animation(_ token: String, durationMs: Double) -> Animation {
      let seconds = durationMs / 1000
      switch token {
      case easeIn:
        return .easeIn(duration: seconds)
      case easeOut:
        return .easeOut(duration: seconds)
      case easeInOut:
        return .easeInOut(duration: seconds)
      default:
        return .easeInOut(duration: seconds)
      }
    }
  }

  // MARK: - Presets

  struct Preset {
    let duration: Double
    let easing: String

    var animation: Animation {
      AppAnimation.ease.animation(easing, durationMs: duration)
    }
  }

  enum presets {
    static let press = Preset(
      duration: duration.fast,
      easing: ease.easeOut
    )

    static let transition = Preset(
      duration: duration.normal,
      easing: ease.easeInOut
    )

    static let modal = Preset(
      duration: duration.slow,
      easing: ease.easeOut
    )
  }
}
