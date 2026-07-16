import SwiftUI

struct IDOSegmentControl<Item: Hashable>: View {
  let items: [Item]
  @Binding var selection: Item
  let title: (Item) -> String
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: AppTheme.spacing.xs) {
        ForEach(items, id: \.self) { item in
          Button {
            withAnimation(
              reduceMotion ? nil : AppTheme.animation.presets.transition.animation
            ) {
              selection = item
            }
          } label: {
            IDOCategoryChip(title: title(item), isSelected: selection == item)
          }
          .buttonStyle(.plain)
          .idoMinTapTarget()
          .accessibilityLabel(title(item))
          .accessibilityAddTraits(selection == item ? [.isButton, .isSelected] : .isButton)
        }
      }
      .padding(.vertical, AppTheme.spacing.xxs)
    }
    .accessibilityElement(children: .contain)
    .accessibilityLabel("フィルター")
  }
}
