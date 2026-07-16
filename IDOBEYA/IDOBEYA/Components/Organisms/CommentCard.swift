import SwiftUI

struct IDOCommentCard: View {
  let comment: AppComment

  var body: some View {
    HStack(alignment: .top, spacing: 10) {
      IDOAvatar(symbol: "person", size: 32)
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text(comment.authorName)
            .font(AppFont.body(.semibold))
            .foregroundStyle(AppTheme.colors.textPrimary)
          Spacer()
          Text(comment.createdAt, style: .relative)
            .font(AppFont.caption())
            .foregroundStyle(AppTheme.colors.textSecondary)
        }
        Text(comment.body)
          .font(AppFont.body())
          .foregroundStyle(AppTheme.colors.textPrimary)
          .lineSpacing(3)
      }
    }
    .padding(12)
    .background(AppTheme.colors.background)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  }
}

// MARK: - Legacy alias

typealias IDOCommentRow = IDOCommentCard
