import SwiftUI

struct IDOEmptyState: View {
  let icon: String
  let title: String
  let message: String
  var actionTitle: String?
  var action: (() -> Void)?

  var body: some View {
    VStack(spacing: Theme.Spacing.sm) {
      Image(systemName: icon)
        .font(.system(size: Theme.IconSize.empty))
        .foregroundStyle(Theme.Color.primary.opacity(0.6))
        .accessibilityHidden(true)
      Text(title)
        .font(IDOFont.heading())
        .foregroundStyle(Theme.Color.text)
        .multilineTextAlignment(.center)
      Text(message)
        .font(IDOFont.body())
        .foregroundStyle(Theme.Color.textSecondary)
        .multilineTextAlignment(.center)
        .lineSpacing(Theme.Spacing.xxs)
      if let actionTitle, let action {
        IDOButton(title: actionTitle, style: .secondary, isFullWidth: false, action: action)
          .padding(.top, Theme.Spacing.xs)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(Theme.Spacing.xxl)
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(title)。\(message)")
  }
}
