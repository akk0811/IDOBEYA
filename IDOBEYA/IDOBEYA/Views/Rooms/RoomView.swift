import SwiftUI

struct RoomView: View {
  @ObservedObject var store: MockAppStore
  @StateObject private var viewModel: RoomViewModel<MockAppStore>
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  init(store: MockAppStore, room: AppRoom) {
    self.store = store
    _viewModel = StateObject(wrappedValue: RoomViewModel(store: store, room: room))
  }

  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: Theme.Spacing.lg) {
        roomHeader
        postsSection
      }
      .padding(.horizontal, Theme.Spacing.screen)
      .padding(.bottom, Theme.Spacing.thumbClearance)
    }
    .idoScreenBackground()
    .navigationTitle(viewModel.room.name)
    .navigationBarTitleDisplayMode(.inline)
    .safeAreaInset(edge: .bottom) { postInputBar }
    .onAppear { viewModel.onAppear() }
  }

  private var roomHeader: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
      Text(viewModel.room.description)
        .font(IDOFont.body())
        .foregroundStyle(Theme.Color.textSecondary)
        .lineSpacing(Theme.Spacing.xxs)
      HStack(spacing: Theme.Spacing.md) {
        Label("\(viewModel.room.memberCount)人が参加", systemImage: "person.2")
        Label(viewModel.room.category, systemImage: "tag")
      }
      .font(IDOFont.caption(.medium))
      .foregroundStyle(Theme.Color.primary)
      if !viewModel.room.tags.isEmpty {
        IDOTagRow(tags: viewModel.room.tags)
      }
    }
    .padding(Theme.Spacing.md)
    .idoCard()
    .accessibilityElement(children: .combine)
    .accessibilityLabel(A11y.roomCard(viewModel.room, compact: false))
  }

  private var postsSection: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
      IDOHeader(title: "投稿").accessibilityAddTraits(.isHeader)
      if viewModel.roomPosts.isEmpty {
        IDOEmptyState(
          icon: "text.bubble",
          title: "まだ投稿がありません",
          message: "最初の投稿をしてみましょう"
        )
      } else {
        ForEach(viewModel.roomPosts) { post in
          PostWithComments(post: post, viewModel: viewModel, reduceMotion: reduceMotion)
        }
      }
    }
  }

  private var postInputBar: some View {
    NavigationLink {
      ComposePostView(store: store, preselectedRoomID: viewModel.room.id)
    } label: {
      IDOFloatingButton(icon: "square.and.pencil", title: "投稿する…") {}
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.Spacing.screen)
        .padding(.vertical, Theme.Spacing.xs)
    }
    .buttonStyle(.plain)
    .accessibilityLabel("投稿する")
    .accessibilityHint("この部屋に新しい投稿を作成します")
    .background(.ultraThinMaterial)
  }
}

private struct PostWithComments: View {
  let post: AppPost
  @ObservedObject var viewModel: RoomViewModel<MockAppStore>
  let reduceMotion: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
      IDOPostCard(post: post, showRoom: false) {
        viewModel.toggleLike(postID: post.id)
      }
      .onTapGesture {
        withAnimation(Motion.standard(reduceMotion: reduceMotion)) {
          viewModel.togglePostExpansion(post.id)
        }
      }
      .accessibilityHint("ダブルタップでコメントを表示します")
      if viewModel.selectedPostID == post.id {
        CommentsBlock(post: post, viewModel: viewModel)
      }
    }
  }
}

private struct CommentsBlock: View {
  let post: AppPost
  @ObservedObject var viewModel: RoomViewModel<MockAppStore>

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
      ForEach(viewModel.comments(for: post.id)) { comment in
        IDOCommentCard(comment: comment)
      }
      HStack(spacing: Theme.Spacing.xs) {
        IDOInput(placeholder: "コメントを書く…", text: $viewModel.commentText)
        Button { viewModel.submitComment(postID: post.id) } label: {
          Image(systemName: "paperplane.fill")
            .foregroundStyle(Theme.Color.primary)
            .frame(width: Theme.Spacing.minTapTarget, height: Theme.Spacing.minTapTarget)
            .background(Theme.Color.surface)
            .clipShape(Circle())
        }
        .buttonStyle(IDOPressButtonStyle())
        .accessibilityLabel("コメントを送信")
      }
    }
    .padding(.horizontal, Theme.Spacing.xxs)
  }
}
