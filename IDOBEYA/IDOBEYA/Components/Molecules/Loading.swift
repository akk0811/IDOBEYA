import SwiftUI

struct IDOLoading: View {
  var message: String?

  var body: some View {
    VStack(spacing: 12) {
      ProgressView()
        .tint(IDOTheme.primary)
      if let message {
        Text(message)
          .font(IDOFont.caption())
          .foregroundStyle(IDOTheme.textSecondary)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct IDOLoadingOverlay: ViewModifier {
  let isLoading: Bool
  var message: String?

  func body(content: Content) -> some View {
    content.overlay {
      if isLoading {
        ZStack {
          IDOTheme.background.opacity(0.6)
          IDOLoading(message: message)
        }
        .ignoresSafeArea()
      }
    }
  }
}

extension View {
  func idoLoading(_ isLoading: Bool, message: String? = nil) -> some View {
    modifier(IDOLoadingOverlay(isLoading: isLoading, message: message))
  }
}
