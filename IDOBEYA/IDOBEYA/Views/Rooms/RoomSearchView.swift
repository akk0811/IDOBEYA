import SwiftUI

struct RoomSearchView: View {
  @ObservedObject var store: MockAppStore
  @StateObject private var viewModel: RoomSearchViewModel<MockAppStore>
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  init(store: MockAppStore) {
    self.store = store
    _viewModel = StateObject(wrappedValue: RoomSearchViewModel(store: store))
  }

  var body: some View {
    NavigationStack {
      ScreenScrollView {
        IDOSearchBar(text: $viewModel.query)
        categorySection
        tagSection
        roomListSection
      }
      .navigationTitle("部屋を探す")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink { CreateRoomView(store: store) } label: {
            Image(systemName: "plus.circle")
              .foregroundStyle(Theme.Color.primary)
          }
          .idoMinTapTarget()
          .accessibilityLabel("部屋を作成")
          .accessibilityHint("新しい部屋を作成します")
        }
      }
      .navigationDestination(for: AppRoom.self) { room in
        RoomView(store: store, room: room)
      }
    }
  }

  private var categorySection: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
      IDOHeader(title: "カテゴリ").accessibilityAddTraits(.isHeader)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: Theme.Spacing.xs) {
          filterChip(title: "すべて", isSelected: viewModel.selectedCategory == nil) {
            viewModel.selectedCategory = nil
          }
          ForEach(RoomCategory.allCases) { category in
            filterChip(
              title: category.rawValue,
              icon: category.icon,
              isSelected: viewModel.selectedCategory == category.rawValue
            ) {
              viewModel.selectedCategory = viewModel.selectedCategory == category.rawValue
                ? nil : category.rawValue
            }
          }
        }
        .padding(.vertical, Theme.Spacing.xxs)
      }
    }
  }

  private var tagSection: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
      IDOHeader(title: "タグ").accessibilityAddTraits(.isHeader)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: Theme.Spacing.xs) {
          ForEach(viewModel.popularTags, id: \.self) { tag in
            filterChip(title: "#\(tag)", isSelected: viewModel.selectedTag == tag) {
              viewModel.selectedTag = viewModel.selectedTag == tag ? nil : tag
            }
          }
        }
        .padding(.vertical, Theme.Spacing.xxs)
      }
    }
  }

  private var roomListSection: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
      HStack {
        IDOHeader(title: "部屋一覧").accessibilityAddTraits(.isHeader)
        Spacer()
        Text("\(viewModel.filteredRooms.count)件")
          .font(IDOFont.caption())
          .foregroundStyle(Theme.Color.textSecondary)
          .accessibilityLabel("\(viewModel.filteredRooms.count)件の部屋")
      }
      if viewModel.filteredRooms.isEmpty {
        IDOEmptyState(
          icon: "magnifyingglass",
          title: "見つかりませんでした",
          message: "別のキーワードやカテゴリで試してみてください"
        )
      } else {
        LazyVStack(spacing: Theme.Spacing.sm) {
          ForEach(viewModel.filteredRooms) { room in
            NavigationLink(value: room) {
              IDORoomCard(room: room)
            }
            .buttonStyle(.plain)
            .idoAccessibility(A11y.roomCard(room, compact: false), hint: "部屋の詳細を表示します", traits: .isButton)
          }
        }
      }
    }
  }

  private func filterChip(
    title: String,
    icon: String? = nil,
    isSelected: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button {
      withAnimation(Motion.standard(reduceMotion: reduceMotion)) { action() }
    } label: {
      IDOCategoryChip(title: title, icon: icon, isSelected: isSelected)
    }
    .buttonStyle(.plain)
    .idoMinTapTarget()
    .accessibilityLabel(title)
    .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
  }
}
