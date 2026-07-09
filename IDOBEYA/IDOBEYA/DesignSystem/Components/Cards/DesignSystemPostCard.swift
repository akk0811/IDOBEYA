import SwiftUI

struct PostCard: View {
  let authorName: String
  let avatarImageURL: URL?
  let createdAt: Date
  let bodyText: String
  let likeCount: Int
  let commentCount: Int
  var isLiked: Bool = false
  var onTap: (() -> Void)?

  var body: some View {
    Group {
      if let onTap {
        Button(action: onTap) { cardContent }
          .buttonStyle(.plain)
      } else {
        cardContent
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(authorName)の投稿、いいね\(likeCount)件、コメント\(commentCount)件")
  }

  private var cardContent: some View {
    BaseCard {
      VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
        header
        Text(bodyText)
          .font(AppTheme.typography.presets.body.font())
          .foregroundStyle(AppTheme.colors.textPrimary)
          .multilineTextAlignment(.leading)
          .frame(maxWidth: .infinity, alignment: .leading)
        footer
      }
    }
  }

  private var header: some View {
    HStack(spacing: AppTheme.spacing.sm) {
      UserAvatar(name: authorName, imageURL: avatarImageURL, size: .sm)
      VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
        Text(authorName)
          .font(AppTheme.typography.presets.subHeading.font())
          .foregroundStyle(AppTheme.colors.textPrimary)
          .lineLimit(1)
        Text(relativeDateString(from: createdAt))
          .font(AppTheme.typography.presets.caption.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
      }
      Spacer(minLength: 0)
    }
  }

  private var footer: some View {
    HStack(spacing: AppTheme.spacing.lg) {
      statItem(
        systemName: isLiked ? "heart.fill" : "heart",
        count: likeCount,
        tint: isLiked ? AppTheme.colors.accent : AppTheme.colors.textSecondary
      )
      statItem(systemName: "bubble.left", count: commentCount, tint: AppTheme.colors.textSecondary)
      Spacer()
    }
    .padding(.top, AppTheme.spacing.xxs)
  }

  private func statItem(systemName: String, count: Int, tint: Color) -> some View {
    HStack(spacing: AppTheme.spacing.xxs) {
      Image(systemName: systemName)
        .font(.system(size: AppTheme.typography.sizes.caption, weight: AppTheme.typography.weights.medium))
      Text("\(count)")
        .font(AppTheme.typography.presets.caption.font())
    }
    .foregroundStyle(tint)
  }

  private func relativeDateString(from date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.locale = Locale(identifier: "ja_JP")
    formatter.unitsStyle = .short
    return formatter.localizedString(for: date, relativeTo: Date())
  }
}

#Preview {
  PostCard(
    authorName: "あきこ",
    avatarImageURL: nil,
    createdAt: Date().addingTimeInterval(-3600),
    bodyText: "今日は新しい読書部屋に参加しました。みなさんのおすすめ本、ぜひ教えてください！",
    likeCount: 24,
    commentCount: 8,
    isLiked: true
  )
  .padding()
  .background(AppTheme.colors.background)
}
