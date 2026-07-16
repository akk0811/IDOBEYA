import SwiftUI

struct IDOLoading: View {
  var message: String?

  var body: some View {
    VStack(spacing: AppTheme.spacing.sm) {
      ProgressView()
        .tint(AppTheme.colors.primary)
      if let message {
        Text(message)
          .font(AppFont.caption())
          .foregroundStyle(AppTheme.colors.textSecondary)
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
          AppTheme.colors.background.opacity(0.6)
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
