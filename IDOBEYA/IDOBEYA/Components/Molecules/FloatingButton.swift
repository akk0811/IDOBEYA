import SwiftUI

struct IDOFloatingButton: View {
  let icon: String
  let title: String?
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        Image(systemName: icon)
        if let title {
          Text(title)
            .font(IDOFont.body())
        }
      }
      .foregroundStyle(IDOTheme.textSecondary)
      .padding(.horizontal, title == nil ? 16 : 20)
      .padding(.vertical, 16)
      .background(IDOTheme.card)
      .clipShape(Capsule())
      .shadow(color: IDOTheme.cardShadow, radius: 8, x: 0, y: 2)
    }
    .buttonStyle(IDOPressButtonStyle())
  }
}
