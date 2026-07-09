import SwiftUI

/// IDOBEYA Design System v1.0 — SwiftUI
///
/// アプリ全体のデザイントークンを一元エクスポートします。
/// TypeScript `theme/index.ts` の `theme` オブジェクトと同一構造です。
///
/// ```swift
/// Text("Hello")
///   .foregroundStyle(AppTheme.colors.primary)
///   .padding(AppTheme.spacing.md)
///   .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large))
/// ```
enum AppTheme {
  typealias colors = AppColors
  typealias typography = AppTypography
  typealias spacing = AppSpacing
  typealias radius = AppRadius
  typealias shadow = AppShadow
  typealias animation = AppAnimation
}
