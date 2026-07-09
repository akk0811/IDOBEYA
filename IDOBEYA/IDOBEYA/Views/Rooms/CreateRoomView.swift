import SwiftUI

struct CreateRoomView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel: CreateRoomViewModel<MockAppStore>

  init(store: MockAppStore) {
    _viewModel = StateObject(wrappedValue: CreateRoomViewModel(store: store))
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
        introCard
        formSection
        CreateRoomVisibilitySection(visibility: $viewModel.visibility)
        tagSection
      }
      .padding(Theme.Spacing.screen)
    }
    .idoScreenBackground()
    .navigationTitle("部屋を作成")
    .navigationBarTitleDisplayMode(.inline)
    .safeAreaInset(edge: .bottom) {
      IDOButton(
        title: "部屋を作成する",
        isLoading: viewModel.isCreating,
        isDisabled: !viewModel.canCreate
      ) {
        viewModel.createRoom { dismiss() }
      }
      .padding(Theme.Spacing.screen)
      .background(Theme.Color.background)
    }
  }

  private var introCard: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
      Text("あなたの居場所を作りましょう")
        .font(IDOFont.heading())
        .foregroundStyle(Theme.Color.text)
      Text("目的や雰囲気が伝わる部屋名と説明を書くと、同じ想いの人が集まりやすくなります。")
        .font(IDOFont.body())
        .foregroundStyle(Theme.Color.textSecondary)
        .lineSpacing(Theme.Spacing.xxs)
    }
    .padding(Theme.Spacing.md)
    .idoCard()
  }

  private var formSection: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
      FormField(title: "部屋名") {
        IDOInput(placeholder: "例：ゆるやかカフェ部屋", text: $viewModel.name)
      }
      FormField(title: "説明") {
        IDOTextArea(placeholder: "どんな部屋か説明してください", text: $viewModel.description, lineLimit: 3...6)
      }
      FormField(title: "カテゴリ") {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: Theme.Spacing.xs) {
            ForEach(RoomCategory.allCases) { category in
              Button { viewModel.selectedCategory = category.rawValue } label: {
                IDOCategoryChip(
                  title: category.rawValue,
                  icon: category.icon,
                  isSelected: viewModel.selectedCategory == category.rawValue
                )
              }
              .buttonStyle(.plain)
            }
          }
        }
      }
    }
  }

  private var tagSection: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
      Text("タグ")
        .font(IDOFont.body(.medium))
        .foregroundStyle(Theme.Color.textSecondary)
      HStack(spacing: Theme.Spacing.xs) {
        IDOInput(placeholder: "タグを入力", text: $viewModel.tagInput)
        Button("追加", action: viewModel.addTag)
          .font(IDOFont.body(.medium))
          .foregroundStyle(Theme.Color.primary)
      }
      if !viewModel.tags.isEmpty {
        FlowLayout(spacing: Theme.Spacing.xs) {
          ForEach(viewModel.tags, id: \.self) { tag in
            RemovableTagChip(tag: tag) { viewModel.removeTag(tag) }
          }
        }
      }
    }
  }
}

private struct FormField<Content: View>: View {
  let title: String
  @ViewBuilder let content: () -> Content

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
      Text(title)
        .font(IDOFont.body(.medium))
        .foregroundStyle(Theme.Color.textSecondary)
      content()
    }
  }
}

private struct RemovableTagChip: View {
  let tag: String
  let onRemove: () -> Void

  var body: some View {
    HStack(spacing: Theme.Spacing.xxs) {
      IDOTag(text: tag)
      Button(action: onRemove) {
        Image(systemName: "xmark")
          .font(.caption2)
      }
    }
    .foregroundStyle(Theme.Color.primary)
    .padding(.horizontal, Theme.Spacing.sm)
    .padding(.vertical, Theme.Spacing.xs - 2)
    .background(Theme.Color.primary.opacity(0.1))
    .clipShape(Capsule())
  }
}
