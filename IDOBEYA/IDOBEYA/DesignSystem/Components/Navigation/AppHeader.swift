import SwiftUI

struct AppHeader: View {
  let title: String
  var subtitle: String?
  var leadingIcon: String?
  var leadingAccessibilityLabel: String = "戻る"
  var trailingIcon: String?
  var trailingAccessibilityLabel: String = "メニュー"
  var onLeadingTap: (() -> Void)?
  var onTrailingTap: (() -> Void)?

  var body: some View {
    VStack(spacing: AppTheme.spacing.xxs) {
      HStack(spacing: AppTheme.spacing.sm) {
        leadingButton
        Spacer(minLength: AppTheme.spacing.xs)
        titleBlock
        Spacer(minLength: AppTheme.spacing.xs)
        trailingButton
      }
      .frame(minHeight: AppTheme.spacing.huge)
    }
    .padding(.horizontal, AppTheme.spacing.md)
    .padding(.vertical, AppTheme.spacing.sm)
    .background(AppTheme.colors.surface)
    .overlay(alignment: .bottom) {
      Rectangle()
        .fill(AppTheme.colors.border)
        .frame(height: 1)
    }
    .accessibilityElement(children: .contain)
  }

  @ViewBuilder
  private var leadingButton: some View {
    if let leadingIcon, let onLeadingTap {
      IconCircleButton(
        systemName: leadingIcon,
        backgroundStyle: .background,
        accessibilityLabel: leadingAccessibilityLabel,
        action: onLeadingTap
      )
    } else {
      Color.clear
        .frame(width: AppTheme.spacing.huge, height: AppTheme.spacing.huge)
    }
  }

  @ViewBuilder
  private var trailingButton: some View {
    if let trailingIcon, let onTrailingTap {
      IconCircleButton(
        systemName: trailingIcon,
        backgroundStyle: .background,
        accessibilityLabel: trailingAccessibilityLabel,
        action: onTrailingTap
      )
    } else {
      Color.clear
        .frame(width: AppTheme.spacing.huge, height: AppTheme.spacing.huge)
    }
  }

  private var titleBlock: some View {
    VStack(spacing: AppTheme.spacing.xxs) {
      Text(title)
        .font(AppTheme.typography.presets.heading.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .lineLimit(2)
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
      if let subtitle {
        Text(subtitle)
          .font(AppTheme.typography.presets.caption.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
          .lineLimit(2)
          .multilineTextAlignment(.center)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .frame(maxWidth: .infinity)
    .layoutPriority(1)
    .accessibilityElement(children: .combine)
    .accessibilityAddTraits(.isHeader)
  }
}

#Preview {
  VStack(spacing: 0) {
    AppHeader(
      title: "ホーム",
      leadingIcon: "chevron.left",
      trailingIcon: "bell",
      onLeadingTap: {},
      onTrailingTap: {}
    )
    AppHeader(
      title: "夜の読書部屋",
      subtitle: "128人が参加",
      leadingIcon: "chevron.left",
      trailingIcon: nil,
      onLeadingTap: {}
    )
    Spacer()
  }
  .background(AppTheme.colors.background)
}
