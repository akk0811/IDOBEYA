import SwiftUI

struct IDOHeader: View {
  enum Style {
    case section(title: String, actionTitle: String? = nil, action: (() -> Void)? = nil)
    case greeting(subtitle: String, title: String, caption: String)
    case page(title: String, subtitle: String? = nil)
  }

  let style: Style

  var body: some View {
    switch style {
    case .section(let title, let actionTitle, let action):
      sectionHeader(title: title, actionTitle: actionTitle, action: action)
    case .greeting(let subtitle, let title, let caption):
      greetingHeader(subtitle: subtitle, title: title, caption: caption)
    case .page(let title, let subtitle):
      pageHeader(title: title, subtitle: subtitle)
    }
  }

  private func sectionHeader(title: String, actionTitle: String?, action: (() -> Void)?) -> some View {
    HStack {
      Text(title)
        .font(AppFont.heading())
        .foregroundStyle(AppTheme.colors.textPrimary)
      Spacer()
      if let actionTitle, let action {
        Button(actionTitle, action: action)
          .font(AppFont.body(.medium))
          .foregroundStyle(AppTheme.colors.primary)
          .idoMinTapTarget(alignment: .trailing)
      }
    }
  }

  private func greetingHeader(subtitle: String, title: String, caption: String) -> some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      Text(subtitle)
        .font(AppFont.caption())
        .foregroundStyle(AppTheme.colors.textSecondary)
      Text(title)
        .font(AppFont.title())
        .foregroundStyle(AppTheme.colors.textPrimary)
      Text(caption)
        .font(AppFont.body())
        .foregroundStyle(AppTheme.colors.textSecondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func pageHeader(title: String, subtitle: String?) -> some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      Text(title)
        .font(AppFont.title())
        .foregroundStyle(AppTheme.colors.textPrimary)
      if let subtitle {
        Text(subtitle)
          .font(AppFont.body())
          .foregroundStyle(AppTheme.colors.textSecondary)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

typealias IDOSectionHeader = IDOHeader

extension IDOHeader {
  init(title: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
    self.style = .section(title: title, actionTitle: actionTitle, action: action)
  }
}
