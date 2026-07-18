import SwiftUI

struct AppSearchBar: View {
  let placeholder: String
  @Binding var text: String
  var showsCancelButton: Bool = false
  var onCancel: (() -> Void)?

  var body: some View {
    HStack(spacing: AppTheme.spacing.sm) {
      HStack(spacing: AppTheme.spacing.xs) {
        Image(systemName: "magnifyingglass")
          .font(.system(size: AppTheme.typography.sizes.body, weight: AppTheme.typography.weights.medium))
          .foregroundStyle(AppTheme.colors.textSecondary)

        TextField(placeholder, text: $text)
          .font(AppTheme.typography.presets.body.font())
          .foregroundStyle(AppTheme.colors.textPrimary)
          .submitLabel(.search)

        if !text.isEmpty {
          Button {
            text = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(AppTheme.colors.textSecondary)
              .frame(minWidth: AppTheme.spacing.minTapTarget, minHeight: AppTheme.spacing.minTapTarget)
              .contentShape(Rectangle())
          }
          .accessibilityLabel("検索をクリア")
        }
      }
      .padding(.horizontal, AppTheme.spacing.md)
      .padding(.vertical, AppTheme.spacing.xs)
      .frame(minHeight: AppTheme.spacing.minTapTarget)
      .background(AppTheme.colors.surface)
      .overlay(
        RoundedRectangle(cornerRadius: AppTheme.radius.full)
          .stroke(AppTheme.colors.border, lineWidth: 1)
      )
      .clipShape(Capsule())

      if showsCancelButton {
        Button("キャンセル") {
          text = ""
          onCancel?()
        }
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.primary)
        .transition(.move(edge: .trailing).combined(with: .opacity))
      }
    }
    .animation(AppTheme.animation.presets.transition.animation, value: showsCancelButton)
    .accessibilityElement(children: .contain)
    .accessibilityLabel("検索")
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var query = ""
    @State private var activeQuery = "読書"

    var body: some View {
      VStack(spacing: AppTheme.spacing.lg) {
        AppSearchBar(placeholder: "部屋や投稿を検索", text: $query)
        AppSearchBar(
          placeholder: "部屋や投稿を検索",
          text: $activeQuery,
          showsCancelButton: true,
          onCancel: { activeQuery = "" }
        )
      }
      .padding()
      .background(AppTheme.colors.surface)
    }
  }

  return PreviewWrapper()
}
