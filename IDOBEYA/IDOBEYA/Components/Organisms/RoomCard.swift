import SwiftUI

struct IDORoomCard: View {
  let room: AppRoom
  var compact: Bool = false

  var body: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      HStack(alignment: .top, spacing: AppTheme.spacing.sm) {
        VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
          Text(room.name)
            .font(AppFont.heading())
            .foregroundStyle(AppTheme.colors.textPrimary)
            .lineLimit(compact ? 1 : 2)
          if !compact {
            Text(room.description)
              .font(AppFont.body())
              .foregroundStyle(AppTheme.colors.textSecondary)
              .lineLimit(2)
          }
        }
        Spacer(minLength: AppTheme.spacing.xs)
        IDORoomChip(kind: .visibility(room.visibility))
      }

      HStack(spacing: AppTheme.spacing.xs) {
        Label("\(room.memberCount)人", systemImage: "person.2")
          .font(AppFont.caption())
          .foregroundStyle(AppTheme.colors.textSecondary)
        IDOBadge(variant: .label(room.category, color: AppTheme.colors.primary))
        if room.isJoined {
          IDORoomChip(kind: .joined)
        }
      }

      if !compact && !room.tags.isEmpty {
        IDOTagRow(tags: room.tags)
      }
    }
    .padding(AppTheme.spacing.md)
    .idoCard()
    .accessibilityElement(children: .combine)
  }
}
