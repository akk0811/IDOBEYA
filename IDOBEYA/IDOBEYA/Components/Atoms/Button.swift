import SwiftUI

struct IDOButton: View {
  enum Style {
    case primary
    case secondary
    case danger
    case ghost
  }

  let title: String
  var style: Style = .primary
  var isLoading: Bool = false
  var isDisabled: Bool = false
  var isFullWidth: Bool = true
  var accessibilityHint: String?
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Group {
        if isLoading {
          ProgressView().tint(foregroundColor)
        } else {
          Text(title)
            .font(AppFont.body(.semibold))
            .lineLimit(1)
            .minimumScaleFactor(0.85)
        }
      }
      .foregroundStyle(foregroundColor)
      .frame(maxWidth: isFullWidth ? .infinity : nil)
      .frame(minHeight: AppTheme.spacing.minTapTarget)
      .padding(.horizontal, isFullWidth ? AppTheme.spacing.md : AppTheme.spacing.lg)
      .background(backgroundColor)
      .clipShape(Capsule())
      .overlay {
        if style == .secondary {
          Capsule().stroke(AppTheme.colors.border, lineWidth: 1)
        }
      }
    }
    .buttonStyle(AppButtonPressStyle())
    .disabled(isDisabled || isLoading)
    .accessibilityLabel(title)
    .accessibilityHint(accessibilityHint ?? "")
    .accessibilityAddTraits(.isButton)
  }

  private var foregroundColor: Color {
    switch style {
    case .primary: AppTheme.colors.surface
    case .danger: AppTheme.colors.surface
    case .secondary, .ghost: AppTheme.colors.primary
    }
  }

  private var backgroundColor: Color {
    if isDisabled { return AppTheme.colors.primary.opacity(0.4) }
    switch style {
    case .primary: return AppTheme.colors.primary
    case .secondary: return AppTheme.colors.surface
    case .danger: return AppTheme.colors.error
    case .ghost: return AppTheme.colors.background.opacity(0)
    }
  }
}

typealias IDOPrimaryButton = IDOButton
typealias IDOSecondaryButton = IDOButton
