import SwiftUI

@main
struct IDOBEYAApp: App {
  var body: some Scene {
    WindowGroup {
      RootView()
        // StateObject(shared) だと購読が不安定になることがあるため、同一インスタンスを直接渡す
        .environmentObject(MockAppStore.shared)
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
    .onChange(of: store.isAuthenticated) { _, newValue in
      #if DEBUG
      print("Authentication state changed:", newValue)
      #endif
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
