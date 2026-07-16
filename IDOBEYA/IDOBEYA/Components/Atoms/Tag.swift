import SwiftUI

struct IDOTag: View {
  let text: String
  var showsHash: Bool = true

  var body: some View {
    Text(showsHash ? "#\(text)" : text)
      .font(AppFont.caption())
      .foregroundStyle(AppTheme.colors.textSecondary)
  }
}

struct IDOTagRow: View {
  let tags: [String]

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: AppTheme.spacing.xs) {
        ForEach(tags, id: \.self) { tag in
          IDOTag(text: tag)
        }
      }
    }
  }
}
