import SwiftUI

struct RoomCard: View {
  let iconName: String
  let name: String
  let description: String
  let memberCount: Int
  var badges: [AppBadge.Variant] = []
  var moodBadges: [String] = []
  var activityLabel: String?
  var onTap: (() -> Void)?

  var body: some View {
    Group {
      if let onTap {
        Button(action: onTap) { cardContent }
          .buttonStyle(.plain)
      } else {
        cardContent
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(name)、\(memberCount)人が参加")
  }

  private var cardContent: some View {
    BaseCard {
      HStack(alignment: .top, spacing: AppTheme.spacing.sm) {
        roomIcon
        VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
          Text(name)
            .font(AppTheme.typography.presets.subHeading.font())
            .foregroundStyle(AppTheme.colors.textPrimary)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
          if !badges.isEmpty {
            FlowLayout(spacing: AppTheme.spacing.xxs) {
              ForEach(badges.indices, id: \.self) { index in
                AppBadge(variant: badges[index], label: badgeLabel(badges[index]))
              }
            }
          }
          Text(description)
            .font(AppTheme.typography.presets.body.font())
            .foregroundStyle(AppTheme.colors.textSecondary)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
          if !moodBadges.isEmpty {
            FlowLayout(spacing: AppTheme.spacing.xxs) {
              ForEach(moodBadges.prefix(3), id: \.self) { mood in
                RoomMoodBadge(title: mood)
              }
            }
            .padding(.top, AppTheme.spacing.xxs)
          }
          if let activityLabel {
            RoomActivityLabel(text: activityLabel)
              .padding(.top, AppTheme.spacing.xxs)
          }
          memberRow
        }
        Spacer(minLength: 0)
      }
    }
  }

  private var roomIcon: some View {
    Image(systemName: iconName)
      .font(.system(size: AppTheme.typography.sizes.heading, weight: AppTheme.typography.weights.medium))
      .foregroundStyle(AppTheme.colors.primary)
      .frame(width: AppTheme.spacing.xxl, height: AppTheme.spacing.xxl)
      .background(AppTheme.colors.primary.opacity(0.1))
      .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.medium))
      .accessibilityHidden(true)
  }

  private var memberRow: some View {
    HStack(spacing: AppTheme.spacing.xxs) {
      Image(systemName: "person.2")
        .font(.system(size: AppTheme.typography.sizes.caption))
        .accessibilityHidden(true)
      Text("\(memberCount)人が参加")
        .font(AppTheme.typography.presets.caption.font())
    }
    .foregroundStyle(AppTheme.colors.textSecondary)
    .padding(.top, AppTheme.spacing.xxs)
  }

  private func badgeLabel(_ badge: AppBadge.Variant) -> String? {
    switch badge {
    case .hot:
      return "会話中"
    default:
      return nil
    }
  }
}

#Preview {
  VStack(spacing: AppTheme.spacing.md) {
    RoomCard(
      iconName: "book",
      name: "夜の読書部屋",
      description: "毎晩30分、好きな本について語り合う部屋です。",
      memberCount: 128,
      badges: [.hot, .joined],
      moodBadges: ["初心者歓迎", "見るだけOK"],
      activityLabel: "今日も会話中"
    )
    RoomCard(
      iconName: "paintpalette",
      name: "週末ハンドメイド",
      description: "作品を共有して励まし合う趣味の部屋。",
      memberCount: 42,
      badges: [.new]
    )
  }
  .padding()
  .background(AppTheme.colors.background)
}
