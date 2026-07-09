import SwiftUI

/// スクロール性能を優先した画面コンテナ（LazyVStack + 統一余白）
struct ScreenScrollView<Content: View>: View {
  var spacing: CGFloat = Theme.Spacing.lg
  var showsIndicators: Bool = true
  @ViewBuilder let content: () -> Content

  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: spacing) {
        content()
      }
      .padding(.horizontal, Theme.Spacing.screen)
      .padding(.top, Theme.Spacing.xs)
      .padding(.bottom, Theme.Spacing.thumbClearance)
    }
    .scrollIndicators(showsIndicators ? .automatic : .hidden)
    .idoScreenBackground()
  }
}

/// 視線誘導：セクション見出し + コンテンツ
struct ListSection<Content: View, Empty: View>: View {
  let title: String
  let isEmpty: Bool
  var actionTitle: String?
  var action: (() -> Void)?
  @ViewBuilder let content: () -> Content
  @ViewBuilder let empty: () -> Empty

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
      IDOHeader(title: title, actionTitle: actionTitle, action: action)
        .accessibilityAddTraits(.isHeader)
      if isEmpty {
        empty()
      } else {
        content()
      }
    }
  }
}

extension ListSection where Empty == IDOEmptyState {
  init(
    title: String,
    isEmpty: Bool,
    emptyIcon: String,
    emptyTitle: String,
    emptyMessage: String,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.title = title
    self.isEmpty = isEmpty
    self.actionTitle = nil
    self.action = nil
    self.content = content
    self.empty = {
      IDOEmptyState(icon: emptyIcon, title: emptyTitle, message: emptyMessage)
    }
  }
}

/// 部屋一覧セクション
struct RoomListSection: View {
  let title: String
  let rooms: [AppRoom]
  var compact: Bool = true

  var body: some View {
    ListSection(
      title: title,
      isEmpty: rooms.isEmpty,
      emptyIcon: "house",
      emptyTitle: "部屋がありません",
      emptyMessage: "「探す」タブから気になる部屋を見つけてみましょう"
    ) {
      ForEach(rooms) { room in
        NavigationLink(value: room) {
          IDORoomCard(room: room, compact: compact)
        }
        .buttonStyle(.plain)
        .idoAccessibility(A11y.roomCard(room, compact: compact), hint: "部屋の詳細を表示します", traits: .isButton)
      }
    }
  }
}

/// 投稿一覧セクション
struct PostListSection: View {
  let title: String
  let posts: [AppPost]
  var showRoom: Bool = true
  let onLike: (UUID) -> Void

  var body: some View {
    ListSection(
      title: title,
      isEmpty: posts.isEmpty,
      emptyIcon: "square.and.pencil",
      emptyTitle: "まだ投稿がありません",
      emptyMessage: "あなたの思いを投稿してみましょう"
    ) {
      ForEach(posts) { post in
        IDOPostCard(post: post, showRoom: showRoom) {
          onLike(post.id)
        }
        .idoAccessibilityGrouped(A11y.postCard(post))
      }
    }
  }
}
