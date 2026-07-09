import SwiftUI

struct IDOCommentCard: View {
  let comment: AppComment

  var body: some View {
    HStack(alignment: .top, spacing: 10) {
      IDOAvatar(symbol: "person", size: 32)
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text(comment.authorName)
            .font(IDOFont.body(.semibold))
            .foregroundStyle(IDOTheme.text)
          Spacer()
          Text(comment.createdAt, style: .relative)
            .font(IDOFont.caption())
            .foregroundStyle(IDOTheme.textSecondary)
        }
        Text(comment.body)
          .font(IDOFont.body())
          .foregroundStyle(IDOTheme.text)
          .lineSpacing(3)
      }
    }
    .padding(12)
    .background(IDOTheme.background)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  }
}

// MARK: - Legacy alias

typealias IDOCommentRow = IDOCommentCard
