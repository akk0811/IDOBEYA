import SwiftUI

struct IDORoomCard: View {
  let room: AppRoom
  var compact: Bool = false

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
      HStack(alignment: .top, spacing: Theme.Spacing.sm) {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs - 2) {
          Text(room.name)
            .font(IDOFont.heading())
            .foregroundStyle(Theme.Color.text)
            .lineLimit(compact ? 1 : 2)
          if !compact {
            Text(room.description)
              .font(IDOFont.body())
              .foregroundStyle(Theme.Color.textSecondary)
              .lineLimit(2)
          }
        }
        Spacer(minLength: Theme.Spacing.xs)
        IDORoomChip(kind: .visibility(room.visibility))
      }

      HStack(spacing: Theme.Spacing.xs) {
        Label("\(room.memberCount)人", systemImage: "person.2")
          .font(IDOFont.caption())
          .foregroundStyle(Theme.Color.textSecondary)
        IDOBadge(variant: .label(room.category, color: Theme.Color.primary))
        if room.isJoined {
          IDORoomChip(kind: .joined)
        }
      }

      if !compact && !room.tags.isEmpty {
        IDOTagRow(tags: room.tags)
      }
    }
    .padding(Theme.Spacing.md)
    .idoCard()
    .accessibilityElement(children: .combine)
  }
}
