import SwiftUI

struct IDOCategoryChip: View {
  let title: String
  var icon: String?
  var isSelected: Bool = false

  var body: some View {
    HStack(spacing: 4) {
      if let icon {
        Image(systemName: icon)
          .font(.caption2)
      }
      Text(title)
        .font(IDOFont.caption(.medium))
    }
    .foregroundStyle(isSelected ? Theme.Color.selectedChipForeground : Theme.Color.textSecondary)
    .padding(.horizontal, Theme.Spacing.sm + 2)
    .padding(.vertical, Theme.Spacing.xs)
    .background(isSelected ? Theme.Color.primary : Theme.Color.surface)
    .clipShape(Capsule())
    .overlay(
      Capsule()
        .stroke(isSelected ? Theme.Color.background.opacity(0) : Theme.Color.border, lineWidth: 1)
    )
  }
}

// MARK: - Legacy alias

typealias IDOChip = IDOCategoryChip
