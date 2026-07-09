import SwiftUI

struct SettingsView: View {
  @ObservedObject var store: MockAppStore
  @State private var showLogoutConfirm = false

  init(store: MockAppStore) {
    self.store = store
  }

  var body: some View {
    ScrollView {
      VStack(spacing: Theme.Spacing.lg) {
        settingsGroup {
          settingsRow(icon: "person", title: "プロフィール編集", destination: ProfileEditView(store: store))
          settingsRow(icon: "bell", title: "通知設定", destination: SettingsPlaceholderView(title: "通知設定"))
          settingsRow(icon: "hand.raised", title: "プライバシー", destination: SettingsPlaceholderView(title: "プライバシー"))
          settingsRow(icon: "key", title: "アカウント", destination: SettingsPlaceholderView(title: "アカウント"))
        }
        settingsGroup {
          settingsRow(icon: "doc.text", title: "利用規約", destination: SettingsPlaceholderView(title: "利用規約"))
          settingsRow(icon: "lock.doc", title: "プライバシーポリシー", destination: SettingsPlaceholderView(title: "プライバシーポリシー"))
        }
        IDOButton(title: "ログアウト", style: .danger) {
          showLogoutConfirm = true
        }
      }
      .padding(Theme.Spacing.screen)
    }
    .idoScreenBackground()
    .navigationTitle("設定")
    .navigationBarTitleDisplayMode(.inline)
    .confirmationDialog("ログアウトしますか？", isPresented: $showLogoutConfirm, titleVisibility: .visible) {
      Button("ログアウト", role: .destructive) { store.logout() }
      Button("キャンセル", role: .cancel) {}
    }
  }

  private func settingsGroup<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    VStack(spacing: 0) { content() }.idoCard()
  }

  private func settingsRow<Destination: View>(icon: String, title: String, destination: Destination) -> some View {
    NavigationLink { destination } label: {
      HStack(spacing: Theme.Spacing.sm + 2) {
        Image(systemName: icon)
          .foregroundStyle(Theme.Color.primary)
          .frame(width: Theme.Spacing.xl)
        Text(title)
          .font(IDOFont.body())
          .foregroundStyle(Theme.Color.text)
        Spacer()
        Image(systemName: "chevron.right")
          .font(.caption)
          .foregroundStyle(Theme.Color.textSecondary)
      }
      .padding(Theme.Spacing.md)
    }
    .buttonStyle(.plain)
  }
}

struct ProfileEditView: View {
  @StateObject private var viewModel: ProfileEditViewModel<MockAppStore>

  init(store: MockAppStore) {
    _viewModel = StateObject(wrappedValue: ProfileEditViewModel(store: store))
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
      FormField(title: "表示名") { IDOInput(placeholder: "表示名", text: $viewModel.displayName) }
      FormField(title: "自己紹介") { IDOTextArea(placeholder: "自己紹介", text: $viewModel.bio, lineLimit: 3...6) }
      IDOButton(title: "保存する", action: viewModel.save)
      Spacer()
    }
    .padding(Theme.Spacing.screen)
    .idoScreenBackground()
    .navigationTitle("プロフィール編集")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear { viewModel.load() }
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

struct SettingsPlaceholderView: View {
  let title: String

  var body: some View {
    VStack {
      IDOEmptyState(
        icon: "doc.text",
        title: title,
        message: "この画面はUIデモです。バックエンド接続後に実装します。"
      )
      Spacer()
    }
    .padding(Theme.Spacing.screen)
    .idoScreenBackground()
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
  }
}
