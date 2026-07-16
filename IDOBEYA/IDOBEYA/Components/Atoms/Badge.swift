import SwiftUI

struct IDOBadge: View {
  enum Variant {
    case dot
    case count(Int)
    case label(String, color: Color = AppTheme.colors.primary)
  }

  let variant: Variant

  var body: some View {
    switch variant {
    case .dot:
      Circle()
        .fill(AppTheme.colors.primary)
        .frame(width: AppTheme.spacing.xs, height: AppTheme.spacing.xs)
    case .count(let count):
      Text("\(count)")
        .font(AppFont.caption(.semibold))
        .foregroundStyle(AppTheme.colors.surface)
        .padding(.horizontal, AppTheme.spacing.xs)
        .padding(.vertical, AppTheme.spacing.xxs)
        .background(AppTheme.colors.primary)
        .clipShape(Capsule())
    case .label(let text, let color):
      Text(text)
        .font(AppFont.caption(.medium))
        .foregroundStyle(color)
        .padding(.horizontal, AppTheme.spacing.xs)
        .padding(.vertical, AppTheme.spacing.xxs)
        .background(color.opacity(0.1))
        .clipShape(Capsule())
    }
  }
}
