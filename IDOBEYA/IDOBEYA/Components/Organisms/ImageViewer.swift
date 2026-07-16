import SwiftUI

struct IDOImageViewer: View {
  var symbol: String = "photo"
  var height: CGFloat = 140
  var onTap: (() -> Void)?

  @State private var showFullScreen = false

  var body: some View {
    Button {
      if let onTap { onTap() } else { showFullScreen = true }
    } label: {
      RoundedRectangle(cornerRadius: AppTheme.radius.medium, style: .continuous)
        .fill(AppTheme.colors.primary.opacity(0.1))
        .frame(height: height)
        .overlay {
          Image(systemName: symbol)
            .font(.title2)
            .foregroundStyle(AppTheme.colors.primary.opacity(0.5))
        }
    }
    .buttonStyle(.plain)
    .accessibilityLabel("画像")
    .accessibilityHint("ダブルタップで拡大表示します")
    .fullScreenCover(isPresented: $showFullScreen) {
      imageFullScreen
    }
  }

  private var imageFullScreen: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      Image(systemName: symbol)
        .font(AppFont.largeTitle())
        .foregroundStyle(AppTheme.colors.surface.opacity(0.65))
      VStack {
        HStack {
          Spacer()
          Button { showFullScreen = false } label: {
            Image(systemName: "xmark.circle.fill")
              .font(.title2)
              .foregroundStyle(AppTheme.colors.surface.opacity(0.9))
          }
          .idoMinTapTarget()
          .accessibilityLabel("閉じる")
          .padding(AppTheme.spacing.screen)
        }
        Spacer()
      }
    }
  }
}
