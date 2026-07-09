import SwiftUI

struct IDOAvatar: View {
  let symbol: String
  var size: CGFloat = 44
  var tint: Color = IDOTheme.primary

  var body: some View {
    ZStack {
      Circle()
        .fill(tint.opacity(0.12))
      Image(systemName: symbol)
        .font(.system(size: size * 0.4))
        .foregroundStyle(tint)
    }
    .frame(width: size, height: size)
  }
}
