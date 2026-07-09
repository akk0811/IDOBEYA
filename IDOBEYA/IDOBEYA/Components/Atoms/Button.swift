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
            .font(IDOFont.body(.semibold))
            .lineLimit(1)
            .minimumScaleFactor(0.85)
        }
      }
      .foregroundStyle(foregroundColor)
      .frame(maxWidth: isFullWidth ? .infinity : nil)
      .frame(minHeight: Theme.Spacing.minTapTarget)
      .padding(.horizontal, isFullWidth ? Theme.Spacing.md : Theme.Spacing.lg)
      .background(backgroundColor)
      .clipShape(Capsule())
      .overlay {
        if style == .secondary {
          Capsule().stroke(Theme.Color.border, lineWidth: 1)
        }
      }
    }
    .buttonStyle(IDOPressButtonStyle())
    .disabled(isDisabled || isLoading)
    .accessibilityLabel(title)
    .accessibilityHint(accessibilityHint ?? "")
    .accessibilityAddTraits(.isButton)
  }

  private var foregroundColor: Color {
    switch style {
    case .primary: Theme.Color.onPrimary
    case .danger: Theme.Color.onDanger
    case .secondary, .ghost: Theme.Color.primary
    }
  }

  private var backgroundColor: Color {
    if isDisabled { return Theme.Color.primary.opacity(0.4) }
    switch style {
    case .primary: return Theme.Color.primary
    case .secondary: return Theme.Color.surface
    case .danger: return Theme.Color.danger
    case .ghost: return Theme.Color.background.opacity(0)
    }
  }
}

typealias IDOPrimaryButton = IDOButton
typealias IDOSecondaryButton = IDOButton
