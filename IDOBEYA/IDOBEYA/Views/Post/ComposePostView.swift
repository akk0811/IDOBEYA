import SwiftUI

struct ComposePostView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel: ComposePostViewModel<MockAppStore>

  init(store: MockAppStore, preselectedRoomID: UUID? = nil, embeddedInTab: Bool = false) {
    _viewModel = StateObject(
      wrappedValue: ComposePostViewModel(
        store: store,
        preselectedRoomID: preselectedRoomID,
        embeddedInTab: embeddedInTab
      )
    )
  }

  var body: some View {
    Group {
      if viewModel.embeddedInTab {
        content
      } else {
        NavigationStack { content }
      }
    }
  }

  private var content: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
        roomPicker
        textSection
        optionsSection
        if viewModel.includePoll { pollSection }
      }
      .padding(Theme.Spacing.screen)
    }
    .idoScreenBackground()
    .navigationTitle("投稿")
    .navigationBarTitleDisplayMode(viewModel.embeddedInTab ? .large : .inline)
    .toolbar {
      if !viewModel.embeddedInTab {
        ToolbarItem(placement: .cancellationAction) {
          Button("閉じる") { dismiss() }
            .foregroundStyle(Theme.Color.textSecondary)
        }
      }
    }
    .safeAreaInset(edge: .bottom) {
      IDOButton(
        title: "投稿する",
        isLoading: viewModel.isPosting,
        isDisabled: !viewModel.canPost
      ) {
        viewModel.submit { dismiss() }
      }
      .padding(Theme.Spacing.screen)
      .background(Theme.Color.background)
    }
    .onAppear { viewModel.configureInitialRoom() }
  }

  private var roomPicker: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
      Text("投稿先の部屋")
        .font(IDOFont.body(.medium))
        .foregroundStyle(Theme.Color.textSecondary)
      Menu {
        ForEach(viewModel.joinedRooms) { room in
          Button(room.name) { viewModel.selectedRoomID = room.id }
        }
      } label: {
        HStack {
          Text(viewModel.selectedRoomName())
            .font(IDOFont.body())
            .foregroundStyle(Theme.Color.text)
          Spacer()
          Image(systemName: "chevron.down")
            .foregroundStyle(Theme.Color.textSecondary)
        }
        .padding(Theme.Spacing.md)
        .idoCard()
      }
    }
  }

  private var textSection: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
      Text("テキスト")
        .font(IDOFont.body(.medium))
        .foregroundStyle(Theme.Color.textSecondary)
      IDOTextArea(
        placeholder: "今日あったこと、思ったことを書いてみましょう",
        text: $viewModel.bodyText,
        lineLimit: 5...12
      )
    }
  }

  private var optionsSection: some View {
    VStack(spacing: 0) {
      optionRow(icon: "photo", title: "画像を添付", isOn: $viewModel.includeImage)
      Divider().padding(.leading, Theme.Spacing.xxl + Theme.Spacing.md)
      optionRow(icon: "chart.bar", title: "アンケートを追加", isOn: $viewModel.includePoll)
      Divider().padding(.leading, Theme.Spacing.xxl + Theme.Spacing.md)
      optionRow(icon: "eye.slash", title: "匿名で投稿", isOn: $viewModel.isAnonymous)
    }
    .idoCard()
  }

  private func optionRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
    Toggle(isOn: isOn) {
      HStack(spacing: Theme.Spacing.sm) {
        Image(systemName: icon)
          .foregroundStyle(Theme.Color.primary)
          .frame(width: Theme.Spacing.xl)
        Text(title)
          .font(IDOFont.body())
          .foregroundStyle(Theme.Color.text)
      }
    }
    .tint(Theme.Color.primary)
    .padding(Theme.Spacing.md)
  }

  private var pollSection: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
      Text("アンケートの質問")
        .font(IDOFont.body(.medium))
        .foregroundStyle(Theme.Color.textSecondary)
      IDOInput(placeholder: "例：どちらが好きですか？", text: $viewModel.pollQuestion)
    }
  }
}
