import SwiftUI

struct HomeView: View {
  @ObservedObject var store: MockAppStore
  @StateObject private var viewModel: HomeViewModel<MockAppStore>

  init(store: MockAppStore) {
    self.store = store
    _viewModel = StateObject(wrappedValue: HomeViewModel(store: store))
  }

  var body: some View {
    NavigationStack {
      ScreenScrollView {
        IDOHeader(
          style: .greeting(
            subtitle: viewModel.greeting,
            title: viewModel.userName,
            caption: viewModel.catchCopy
          )
        )
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)

        RoomListSection(title: "おすすめの部屋", rooms: viewModel.recommendedRooms)
        RoomListSection(title: "人気の部屋", rooms: viewModel.popularRooms)
        RoomListSection(title: "最近見た部屋", rooms: viewModel.recentRooms)

        PostListSection(
          title: "新着投稿",
          posts: viewModel.latestPosts,
          onLike: viewModel.toggleLike(postID:)
        )
      }
      .navigationBarHidden(true)
      .navigationDestination(for: AppRoom.self) { room in
        RoomView(store: store, room: room)
      }
    }
  }
}
