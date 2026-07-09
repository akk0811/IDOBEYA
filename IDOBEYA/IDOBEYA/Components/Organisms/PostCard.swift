import SwiftUI

struct IDOPostCard: View {
  let post: AppPost
  var showRoom: Bool = true
  var onLike: (() -> Void)?

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
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
    .padding(Theme.Spacing.md)
    .idoCard()
    .accessibilityElement(children: .contain)
  }

  private var postHeader: some View {
    HStack(spacing: Theme.Spacing.sm) {
      IDOAvatar(
        symbol: post.isAnonymous ? "person.fill.questionmark" : "leaf.fill",
        size: Theme.IconSize.avatarMd
      )
      VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
        Text(post.authorName)
          .font(IDOFont.body(.semibold))
          .foregroundStyle(Theme.Color.text)
        if showRoom {
          Text(post.roomName)
            .font(IDOFont.caption())
            .foregroundStyle(Theme.Color.textSecondary)
        }
      }
      Spacer(minLength: Theme.Spacing.xs)
      Text(post.createdAt, style: .relative)
        .font(IDOFont.caption())
        .foregroundStyle(Theme.Color.textSecondary)
        .accessibilityLabel("投稿から\(post.createdAt.formatted(.relative(presentation: .named)))")
    }
  }

  private var postBody: some View {
    Text(post.body)
      .font(IDOFont.body())
      .foregroundStyle(Theme.Color.text)
      .lineSpacing(Theme.Spacing.xxs)
      .fixedSize(horizontal: false, vertical: true)
  }

  private func pollSection(_ poll: AppPoll) -> some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
      Text(poll.question)
        .font(IDOFont.body(.medium))
        .foregroundStyle(Theme.Color.text)
        .accessibilityAddTraits(.isHeader)
      ForEach(poll.options) { option in
        HStack {
          Text(option.text)
            .font(IDOFont.body())
          Spacer()
          Text("\(option.voteCount)票")
            .font(IDOFont.caption())
            .foregroundStyle(Theme.Color.textSecondary)
        }
        .padding(Theme.Spacing.sm)
        .background(Theme.Color.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous))
        .accessibilityLabel("\(option.text)、\(option.voteCount)票")
      }
    }
    .accessibilityElement(children: .combine)
  }

  private var postActions: some View {
    HStack(spacing: Theme.Spacing.lg) {
      Button {
        onLike?()
      } label: {
        Label("\(post.likeCount)", systemImage: post.isLiked ? "heart.fill" : "heart")
          .font(IDOFont.caption(.medium))
          .foregroundStyle(post.isLiked ? Theme.Color.accent : Theme.Color.textSecondary)
      }
      .buttonStyle(.plain)
      .idoMinTapTarget()
      .accessibilityLabel(A11y.likeButton(isLiked: post.isLiked, count: post.likeCount))
      .accessibilityHint("ダブルタップでいいねを切り替えます")

      Label("\(post.commentCount)", systemImage: "bubble.left")
        .font(IDOFont.caption(.medium))
        .foregroundStyle(Theme.Color.textSecondary)
        .accessibilityLabel(A11y.commentCount(post.commentCount))
    }
  }
}
