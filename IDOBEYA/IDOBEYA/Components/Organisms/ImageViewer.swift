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
      RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
        .fill(Theme.Color.imagePlaceholder)
        .frame(height: height)
        .overlay {
          Image(systemName: symbol)
            .font(.title2)
            .foregroundStyle(Theme.Color.primary.opacity(0.5))
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
      Theme.Color.scrim.ignoresSafeArea()
      Image(systemName: symbol)
        .font(IDOFont.largeTitle())
        .foregroundStyle(Theme.Color.iconOnScrimMuted)
      VStack {
        HStack {
          Spacer()
          Button { showFullScreen = false } label: {
            Image(systemName: "xmark.circle.fill")
              .font(.title2)
              .foregroundStyle(Theme.Color.iconOnScrim)
          }
          .idoMinTapTarget()
          .accessibilityLabel("閉じる")
          .padding(Theme.Spacing.screen)
        }
        Spacer()
      }
    }
  }
}
