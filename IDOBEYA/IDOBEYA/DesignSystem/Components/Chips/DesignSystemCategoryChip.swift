import SwiftUI

struct CategoryChip: View {
  enum Category: String, CaseIterable, Identifiable {
    case hobby = "趣味"
    case consultation = "相談"
    case lifestyle = "生活"
    case learning = "学び"
    case travel = "旅行"
    case catLovers = "猫好き"

    var id: String { rawValue }

    var systemImage: String {
      switch self {
      case .hobby: "paintpalette"
      case .consultation: "bubble.left.and.bubble.right"
      case .lifestyle: "house"
      case .learning: "book"
      case .travel: "airplane"
      case .catLovers: "cat"
      }
    }
  }

  let category: Category
  var isSelected: Bool = false
  let action: () -> Void

  var body: some View {
    AppChip(
      title: category.rawValue,
      systemImage: category.systemImage,
      isSelected: isSelected,
      action: action
    )
  }
}

#Preview {
  ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: AppTheme.spacing.xs) {
      ForEach(CategoryChip.Category.allCases) { category in
        CategoryChip(
          category: category,
          isSelected: category == .hobby,
          action: {}
        )
      }
    }
    .padding(.horizontal, AppTheme.spacing.md)
  }
  .background(AppTheme.colors.background)
}
