import SwiftUI

struct IDOCategoryChip: View {
  let title: String
  var icon: String?
  var isSelected: Bool = false

  var body: some View {
    HStack(spacing: AppTheme.spacing.xxs) {
      if let icon {
        Image(systemName: icon)
          .font(.system(size: AppTheme.typography.sizes.caption, weight: AppTheme.typography.weights.medium))
      }
      Text(title)
        .font(AppFont.caption(.medium))
    }
    .foregroundStyle(isSelected ? AppTheme.colors.surface : AppTheme.colors.textSecondary)
    .padding(.horizontal, AppTheme.spacing.sm)
    .padding(.vertical, AppTheme.spacing.xs)
    .background(isSelected ? AppTheme.colors.primary : AppTheme.colors.surface)
    .clipShape(Capsule())
    .overlay(
      Capsule()
        .stroke(isSelected ? AppTheme.colors.background.opacity(0) : AppTheme.colors.border, lineWidth: 1)
    )
  }
}

// MARK: - Legacy alias

typealias IDOChip = IDOCategoryChip
