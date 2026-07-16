import SwiftUI

struct IDOPostCard: View {
  let post: AppPost
  var showRoom: Bool = true
  var onLike: (() -> Void)?

  var body: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      postHeader
      postBody
      if post.imageSymbol != nil {
        IDOImageViewer(symbol: post.imageSymbol ?? "photo")
      }
      if let poll = post.poll {
        pollSection(poll)
      }
      postActions
    }
    .padding(AppTheme.spacing.md)
    .idoCard()
    .accessibilityElement(children: .contain)
  }

  private var postHeader: some View {
    HStack(spacing: AppTheme.spacing.sm) {
      IDOAvatar(
        symbol: post.isAnonymous ? "person.fill.questionmark" : "leaf.fill",
        size: AppTheme.iconSize.avatarMd
      )
      VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
        Text(post.authorName)
          .font(AppFont.body(.semibold))
          .foregroundStyle(AppTheme.colors.textPrimary)
        if showRoom {
          Text(post.roomName)
            .font(AppFont.caption())
            .foregroundStyle(AppTheme.colors.textSecondary)
        }
      }
      Spacer(minLength: AppTheme.spacing.xs)
      Text(post.createdAt, style: .relative)
        .font(AppFont.caption())
        .foregroundStyle(AppTheme.colors.textSecondary)
        .accessibilityLabel("投稿から\(post.createdAt.formatted(.relative(presentation: .named)))")
    }
  }

  private var postBody: some View {
    Text(post.body)
      .font(AppFont.body())
      .foregroundStyle(AppTheme.colors.textPrimary)
      .lineSpacing(AppTheme.spacing.xxs)
      .fixedSize(horizontal: false, vertical: true)
  }

  private func pollSection(_ poll: AppPoll) -> some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
      Text(poll.question)
        .font(AppFont.body(.medium))
        .foregroundStyle(AppTheme.colors.textPrimary)
        .accessibilityAddTraits(.isHeader)
      ForEach(poll.options) { option in
        HStack {
          Text(option.text)
            .font(AppFont.body())
          Spacer()
          Text("\(option.voteCount)票")
            .font(AppFont.caption())
            .foregroundStyle(AppTheme.colors.textSecondary)
        }
        .padding(AppTheme.spacing.sm)
        .background(AppTheme.colors.background)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small, style: .continuous))
        .accessibilityLabel("\(option.text)、\(option.voteCount)票")
      }
    }
    .accessibilityElement(children: .combine)
  }

  private var postActions: some View {
    HStack(spacing: AppTheme.spacing.lg) {
      Button {
        onLike?()
      } label: {
        Label("\(post.likeCount)", systemImage: post.isLiked ? "heart.fill" : "heart")
          .font(AppFont.caption(.medium))
          .foregroundStyle(post.isLiked ? AppTheme.colors.accent : AppTheme.colors.textSecondary)
      }
      .buttonStyle(.plain)
      .idoMinTapTarget()
      .accessibilityLabel(A11y.likeButton(isLiked: post.isLiked, count: post.likeCount))
      .accessibilityHint("ダブルタップでいいねを切り替えます")

      Label("\(post.commentCount)", systemImage: "bubble.left")
        .font(AppFont.caption(.medium))
        .foregroundStyle(AppTheme.colors.textSecondary)
        .accessibilityLabel(A11y.commentCount(post.commentCount))
    }
  }
}
