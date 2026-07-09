import SwiftUI

struct IDOBadge: View {
  enum Variant {
    case dot
    case count(Int)
    case label(String, color: Color = Theme.Color.primary)
  }

  let variant: Variant

  var body: some View {
    switch variant {
    case .dot:
      Circle()
        .fill(Theme.Color.primary)
        .frame(width: Theme.Spacing.xs, height: Theme.Spacing.xs)
    case .count(let count):
      Text("\(count)")
        .font(IDOFont.caption(.semibold))
        .foregroundStyle(Theme.Color.onPrimary)
        .padding(.horizontal, Theme.Spacing.xs - 2)
        .padding(.vertical, Theme.Spacing.xxs)
        .background(Theme.Color.primary)
        .clipShape(Capsule())
    case .label(let text, let color):
      Text(text)
        .font(IDOFont.caption(.medium))
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .clipShape(Capsule())
    }
  }
}
