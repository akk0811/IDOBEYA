import SwiftUI

struct ProfileView: View {
  @ObservedObject var store: MockAppStore
  @StateObject private var viewModel: ProfileViewModel<MockAppStore>

  init(store: MockAppStore) {
    self.store = store
    _viewModel = StateObject(wrappedValue: ProfileViewModel(store: store))
  }

  var body: some View {
    NavigationStack {
      ScreenScrollView {
        IDOProfileHeader(
          user: viewModel.user,
          joinedRoomCount: viewModel.joinedRooms.count,
          postCount: viewModel.userPosts.count,
          unreadCount: viewModel.unreadCount
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("プロフィール、\(viewModel.user.displayName)")

        RoomListSection(title: "参加中の部屋", rooms: viewModel.joinedRooms)

        PostListSection(
          title: "投稿一覧",
          posts: viewModel.userPosts,
          onLike: viewModel.toggleLike(postID:)
        )
      }
      .navigationTitle("マイページ")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink {
            SettingsView(store: store)
          } label: {
            Image(systemName: "gearshape")
              .foregroundStyle(Theme.Color.textSecondary)
          }
          .idoMinTapTarget()
          .accessibilityLabel("設定")
          .accessibilityHint("アプリの設定を開きます")
        }
      }
      .navigationDestination(for: AppRoom.self) { room in
        RoomView(store: store, room: room)
      }
    }
  }
}
