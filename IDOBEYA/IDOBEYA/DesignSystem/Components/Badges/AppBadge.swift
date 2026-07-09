import SwiftUI

struct AppBadge: View {
  enum Variant: String, CaseIterable {
    case new = "NEW"
    case hot = "HOT"
    case joined = "参加中"
    case admin = "管理者"
    case official = "運営"

    var foregroundColor: Color {
      switch self {
      case .new: AppTheme.colors.info
      case .hot: AppTheme.colors.accent
      case .joined: AppTheme.colors.primary
      case .admin: AppTheme.colors.warning
      case .official: AppTheme.colors.error
      }
    }

    var backgroundColor: Color {
      foregroundColor.opacity(0.12)
    }
  }

  let variant: Variant
  var label: String?

  private var displayText: String {
    label ?? variant.rawValue
  }

  var body: some View {
    Text(displayText)
      .font(AppTheme.typography.presets.tiny.font())
      .fontWeight(AppTheme.typography.weights.semibold)
      .foregroundStyle(variant.foregroundColor)
      .padding(.horizontal, AppTheme.spacing.xs)
      .padding(.vertical, AppTheme.spacing.xxs)
      .background(variant.backgroundColor)
      .clipShape(Capsule())
      .accessibilityLabel(displayText)
  }
}

#Preview {
  HStack(spacing: AppTheme.spacing.xs) {
    ForEach(AppBadge.Variant.allCases, id: \.self) { variant in
      AppBadge(variant: variant)
    }
  }
  .padding()
  .background(AppTheme.colors.background)
}
