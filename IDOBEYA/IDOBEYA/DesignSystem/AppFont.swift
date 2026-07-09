import SwiftUI

/// `IDOFont` 互換のフォントヘルパー。Design System コンポーネントはこちらを使用します。
enum AppFont {
  static func body(_ weight: Font.Weight = AppTheme.typography.weights.regular) -> Font {
    AppTheme.typography.presets.body.font().weight(weight)
  }

  static func caption(_ weight: Font.Weight = AppTheme.typography.weights.regular) -> Font {
    AppTheme.typography.presets.caption.font().weight(weight)
  }

  static func heading(_ weight: Font.Weight = AppTheme.typography.weights.semibold) -> Font {
    AppTheme.typography.presets.heading.font().weight(weight)
  }

  static func title(_ weight: Font.Weight = AppTheme.typography.weights.bold) -> Font {
    AppTheme.typography.presets.title.font().weight(weight)
  }

  static func subHeading(_ weight: Font.Weight = AppTheme.typography.weights.semibold) -> Font {
    AppTheme.typography.presets.subHeading.font().weight(weight)
  }

  static func display(_ weight: Font.Weight = AppTheme.typography.weights.bold) -> Font {
    AppTheme.typography.presets.display.font().weight(weight)
  }

  static func largeTitle(_ weight: Font.Weight = AppTheme.typography.weights.bold) -> Font {
    display(weight)
  }
}
