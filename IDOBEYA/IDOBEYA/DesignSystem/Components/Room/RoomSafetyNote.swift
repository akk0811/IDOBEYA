import SwiftUI

struct RoomSafetyNote: View {
  let notes: [String]
  var title: String = "安心して使うために"
  var iconName: String = "shield.checkered"

  var body: some View {
    BaseCard {
      VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
        HStack(spacing: AppTheme.spacing.xs) {
          Image(systemName: iconName)
            .font(.system(size: AppTheme.typography.sizes.body, weight: AppTheme.typography.weights.medium))
            .foregroundStyle(AppTheme.colors.primary)
          Text(title)
            .font(AppTheme.typography.presets.subHeading.font())
            .foregroundStyle(AppTheme.colors.textPrimary)
        }

        VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
          ForEach(notes, id: \.self) { note in
            HStack(alignment: .top, spacing: AppTheme.spacing.xs) {
              Image(systemName: "checkmark.circle")
                .font(.system(size: AppTheme.typography.sizes.caption, weight: AppTheme.typography.weights.medium))
                .foregroundStyle(AppTheme.colors.primary)
                .padding(.top, AppTheme.spacing.xxs)
              Text(note)
                .font(AppTheme.typography.presets.body.font())
                .foregroundStyle(AppTheme.colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            }
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  RoomSafetyNote(notes: [
    "この部屋は見るだけでも大丈夫です。",
    "匿名で話せます。",
    "困ったときは通報できます。",
  ])
  .padding()
  .background(AppTheme.colors.background)
}
