import SwiftUI

struct IDOProfileHeader: View {
  let user: AppUser
  var joinedRoomCount: Int
  var postCount: Int
  var unreadCount: Int

  var body: some View {
    VStack(spacing: 16) {
      IDOAvatar(symbol: user.avatarSymbol, size: 72)
      VStack(spacing: 6) {
        Text(user.displayName)
          .font(IDOFont.title())
          .foregroundStyle(IDOTheme.text)
        Text(user.bio)
          .font(IDOFont.body())
          .foregroundStyle(IDOTheme.textSecondary)
          .multilineTextAlignment(.center)
          .lineSpacing(4)
      }
      HStack(spacing: 24) {
        statItem(value: "\(joinedRoomCount)", label: "参加部屋")
        statItem(value: "\(postCount)", label: "投稿")
        statItem(value: "\(unreadCount)", label: "未読")
      }
    }
    .frame(maxWidth: .infinity)
    .padding(24)
    .idoCard()
  }

  private func statItem(value: String, label: String) -> some View {
    VStack(spacing: 4) {
      Text(value)
        .font(IDOFont.heading())
        .foregroundStyle(IDOTheme.primary)
      Text(label)
        .font(IDOFont.caption())
        .foregroundStyle(IDOTheme.textSecondary)
    }
  }
}
