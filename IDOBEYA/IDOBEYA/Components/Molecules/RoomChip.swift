import SwiftUI

struct IDORoomChip: View {
  enum Kind {
    case joined
    case visibility(RoomVisibility)
  }

  let kind: Kind

  var body: some View {
    switch kind {
    case .joined:
      IDOBadge(variant: .label("参加中", color: IDOTheme.accent))
    case .visibility(let visibility):
      Label(label(for: visibility), systemImage: icon(for: visibility))
        .font(IDOFont.caption())
        .foregroundStyle(IDOTheme.textSecondary)
    }
  }

  private func label(for visibility: RoomVisibility) -> String {
    switch visibility {
    case .public: "公開"
    case .inviteOnly: "招待制"
    case .private: "非公開"
    }
  }

  private func icon(for visibility: RoomVisibility) -> String {
    switch visibility {
    case .public: "globe"
    case .inviteOnly: "envelope"
    case .private: "lock"
    }
  }
}
