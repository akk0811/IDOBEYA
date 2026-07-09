import CoreGraphics

/// IDOBEYA Design System — Icon / Avatar sizes
///
/// `AppTheme.spacing` から派生するサイズトークンです。
enum AppIconSize {
  static let avatarSm: CGFloat = AppTheme.spacing.xxl
  static let avatarMd: CGFloat = AppTheme.spacing.xxl + AppTheme.spacing.xxs
  static let avatarLg: CGFloat = AppTheme.spacing.minTapTarget
  static let avatarXl: CGFloat = AppTheme.spacing.massive + AppTheme.spacing.xs
  static let brand: CGFloat = AppTheme.spacing.massive + AppTheme.spacing.lg
  static let notification: CGFloat = AppTheme.spacing.xxxl
  static let empty: CGFloat = AppTheme.spacing.xxl + AppTheme.spacing.xxs
}
