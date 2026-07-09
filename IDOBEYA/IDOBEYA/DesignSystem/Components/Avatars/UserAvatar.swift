import SwiftUI

struct UserAvatar: View {
  enum Size: CaseIterable {
    case xs, sm, md, lg, xl

    var diameter: CGFloat {
      switch self {
      case .xs: AppTheme.spacing.lg
      case .sm: AppTheme.spacing.xxl
      case .md: AppTheme.spacing.xxxl
      case .lg: AppTheme.spacing.huge
      case .xl: AppTheme.spacing.massive
      }
    }

    var fontSize: CGFloat {
      switch self {
      case .xs: AppTheme.typography.sizes.tiny
      case .sm: AppTheme.typography.sizes.caption
      case .md: AppTheme.typography.sizes.body
      case .lg: AppTheme.typography.sizes.subHeading
      case .xl: AppTheme.typography.sizes.title
      }
    }
  }

  let name: String
  var imageURL: URL?
  var size: Size = .md

  var body: some View {
    Group {
      if let imageURL {
        AsyncImage(url: imageURL) { phase in
          switch phase {
          case .success(let image):
            image
              .resizable()
              .scaledToFill()
          default:
            placeholder
          }
        }
      } else {
        placeholder
      }
    }
    .frame(width: size.diameter, height: size.diameter)
    .clipShape(Circle())
    .overlay(
      Circle()
        .stroke(AppTheme.colors.border, lineWidth: 1)
    )
    .accessibilityLabel("\(name)のアバター")
  }

  private var placeholder: some View {
    ZStack {
      AppTheme.colors.primary.opacity(0.12)
      if initials.isEmpty {
        Image(systemName: "person.fill")
          .font(.system(size: size.fontSize, weight: AppTheme.typography.weights.medium))
          .foregroundStyle(AppTheme.colors.primary)
      } else {
        Text(initials)
          .font(.system(size: size.fontSize, weight: AppTheme.typography.weights.semibold))
          .foregroundStyle(AppTheme.colors.primary)
      }
    }
  }

  private var initials: String {
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return "" }
    let parts = trimmed.split(separator: " ")
    if parts.count >= 2 {
      return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
    }
    return String(trimmed.prefix(1)).uppercased()
  }
}

#Preview {
  HStack(spacing: AppTheme.spacing.md) {
    ForEach(UserAvatar.Size.allCases, id: \.self) { size in
      UserAvatar(name: "あきこ", size: size)
    }
  }
  .padding()
  .background(AppTheme.colors.background)
}
