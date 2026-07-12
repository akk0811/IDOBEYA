import SwiftUI

struct SettingsRow: View {
  let iconName: String
  let title: String
  var subtitle: String?
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: AppTheme.spacing.sm) {
        rowIcon

        VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
          Text(title)
            .font(AppTheme.typography.presets.body.font())
            .foregroundStyle(AppTheme.colors.textPrimary)
            .multilineTextAlignment(.leading)

          if let subtitle {
            Text(subtitle)
              .font(AppTheme.typography.presets.caption.font())
              .foregroundStyle(AppTheme.colors.textSecondary)
              .multilineTextAlignment(.leading)
          }
        }

        Spacer(minLength: AppTheme.spacing.xs)

        Image(systemName: "chevron.right")
          .font(.system(size: AppTheme.typography.sizes.caption, weight: AppTheme.typography.weights.semibold))
          .foregroundStyle(AppTheme.colors.textSecondary)
      }
      .padding(.horizontal, AppTheme.spacing.md)
      .padding(.vertical, AppTheme.spacing.sm)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .accessibilityElement(children: .combine)
    .accessibilityLabel(accessibilityText)
    .accessibilityAddTraits(.isButton)
  }

  private var rowIcon: some View {
    Image(systemName: iconName)
      .font(.system(size: AppTheme.typography.sizes.body, weight: AppTheme.typography.weights.medium))
      .foregroundStyle(AppTheme.colors.primary)
      .frame(width: AppTheme.spacing.xl, height: AppTheme.spacing.xl)
      .background(AppTheme.colors.primary.opacity(0.1))
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
  }

  private var accessibilityText: String {
    if let subtitle {
      return "\(title)、\(subtitle)"
    }
    return title
  }
}

struct ToggleSettingsRow: View {
  let iconName: String
  let title: String
  var subtitle: String?
  @Binding var isOn: Bool

  var body: some View {
    HStack(spacing: AppTheme.spacing.sm) {
      rowIcon

      VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
        Text(title)
          .font(AppTheme.typography.presets.body.font())
          .foregroundStyle(AppTheme.colors.textPrimary)
          .multilineTextAlignment(.leading)

        if let subtitle {
          Text(subtitle)
            .font(AppTheme.typography.presets.caption.font())
            .foregroundStyle(AppTheme.colors.textSecondary)
            .multilineTextAlignment(.leading)
        }
      }

      Spacer(minLength: AppTheme.spacing.xs)

      Toggle("", isOn: $isOn)
        .labelsHidden()
        .tint(AppTheme.colors.primary)
    }
    .padding(.horizontal, AppTheme.spacing.md)
    .padding(.vertical, AppTheme.spacing.sm)
    .accessibilityElement(children: .combine)
    .accessibilityLabel(title)
  }

  private var rowIcon: some View {
    Image(systemName: iconName)
      .font(.system(size: AppTheme.typography.sizes.body, weight: AppTheme.typography.weights.medium))
      .foregroundStyle(AppTheme.colors.primary)
      .frame(width: AppTheme.spacing.xl, height: AppTheme.spacing.xl)
      .background(AppTheme.colors.primary.opacity(0.1))
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
  }
}

struct DangerSettingsRow: View {
  let iconName: String
  let title: String
  var subtitle: String?
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: AppTheme.spacing.sm) {
        Image(systemName: iconName)
          .font(.system(size: AppTheme.typography.sizes.body, weight: AppTheme.typography.weights.medium))
          .foregroundStyle(AppTheme.colors.error)
          .frame(width: AppTheme.spacing.xl, height: AppTheme.spacing.xl)
          .background(AppTheme.colors.error.opacity(0.08))
          .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))

        VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
          Text(title)
            .font(AppTheme.typography.presets.body.font())
            .foregroundStyle(AppTheme.colors.error)
            .multilineTextAlignment(.leading)

          if let subtitle {
            Text(subtitle)
              .font(AppTheme.typography.presets.caption.font())
              .foregroundStyle(AppTheme.colors.textSecondary)
              .multilineTextAlignment(.leading)
          }
        }

        Spacer(minLength: AppTheme.spacing.xs)

        Image(systemName: "chevron.right")
          .font(.system(size: AppTheme.typography.sizes.caption, weight: AppTheme.typography.weights.semibold))
          .foregroundStyle(AppTheme.colors.textSecondary)
      }
      .padding(.horizontal, AppTheme.spacing.md)
      .padding(.vertical, AppTheme.spacing.sm)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .accessibilityLabel(title)
    .accessibilityAddTraits(.isButton)
  }
}

struct SettingsSectionView: View {
  let section: SettingsSectionItem
  @Binding var toggleStates: [SettingsToggleID: Bool]
  var onRowTap: (SettingsRowItem) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      Text(section.title)
        .font(AppTheme.typography.presets.heading.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .accessibilityAddTraits(.isHeader)

      if let comfortNote = section.comfortNote {
        safetyComfortCard(comfortNote)
      }

      BaseCard(padding: 0) {
        VStack(spacing: 0) {
          ForEach(Array(section.rows.enumerated()), id: \.element.id) { index, row in
            settingsRowView(for: row)

            if index < section.rows.count - 1 {
              Divider()
                .overlay(AppTheme.colors.border)
                .padding(.leading, AppTheme.spacing.md + AppTheme.spacing.xl + AppTheme.spacing.sm)
            }
          }
        }
      }
    }
  }

  @ViewBuilder
  private func settingsRowView(for row: SettingsRowItem) -> some View {
    switch row.kind {
    case .navigation:
      SettingsRow(
        iconName: row.iconName,
        title: row.title,
        subtitle: row.subtitle,
        action: { onRowTap(row) }
      )
    case .toggle(let toggleID):
      ToggleSettingsRow(
        iconName: row.iconName,
        title: row.title,
        subtitle: row.subtitle,
        isOn: Binding(
          get: { toggleStates[toggleID, default: true] },
          set: { toggleStates[toggleID] = $0 }
        )
      )
    case .danger:
      DangerSettingsRow(
        iconName: row.iconName,
        title: row.title,
        subtitle: row.subtitle,
        action: { onRowTap(row) }
      )
    }
  }

  private func safetyComfortCard(_ text: String) -> some View {
    Text(text)
      .font(AppTheme.typography.presets.body.font())
      .foregroundStyle(AppTheme.colors.textSecondary)
      .fixedSize(horizontal: false, vertical: true)
      .padding(AppTheme.spacing.md)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(AppTheme.colors.primary.opacity(0.06))
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.medium))
      .overlay(
        RoundedRectangle(cornerRadius: AppTheme.radius.medium)
          .stroke(AppTheme.colors.primary.opacity(0.12), lineWidth: 1)
      )
  }
}

#Preview {
  ScrollView {
    VStack(spacing: AppTheme.spacing.lg) {
      SettingsSectionView(
        section: MockSettings.sections[1],
        toggleStates: .constant(MockSettings.defaultToggleStates),
        onRowTap: { _ in }
      )
    }
    .padding()
  }
  .background(AppTheme.colors.background)
}
