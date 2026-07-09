import SwiftUI

@main
struct IDOBEYAApp: App {
  /// 将来 Firebase 実装に差し替える場合はここだけ変更
  @StateObject private var store: MockAppStore = .shared

  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(store)
    }
  }
}

struct RootView: View {
  @EnvironmentObject private var store: MockAppStore

  var body: some View {
    Group {
      if store.isAuthenticated {
        MainTabView()
      } else {
        NavigationStack {
          LoginView(store: store)
        }
      }
    }
  }
}

#Preview("ログイン") {
  NavigationStack {
    LoginView(store: MockAppStore.shared)
  }
}

#Preview("ホーム") {
  MainTabView()
    .environmentObject(MockAppStore.shared)
}
