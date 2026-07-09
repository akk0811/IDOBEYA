import SwiftUI

struct LoadingView: View {
  enum Style {
    case spinner
    case skeleton
  }

  var message: String?
  var style: Style = .spinner

  var body: some View {
    switch style {
    case .spinner:
      spinnerContent
    case .skeleton:
      skeletonContent
    }
  }

  private var spinnerContent: some View {
    VStack(spacing: AppTheme.spacing.md) {
      ProgressView()
        .tint(AppTheme.colors.primary)
        .scaleEffect(1.2)
      if let message {
        Text(message)
          .font(AppTheme.typography.presets.body.font())
          .foregroundStyle(AppTheme.colors.textSecondary)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .accessibilityLabel(message ?? "読み込み中")
  }

  private var skeletonContent: some View {
    VStack(spacing: AppTheme.spacing.md) {
      ForEach(0..<3, id: \.self) { _ in
        VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
          HStack(spacing: AppTheme.spacing.sm) {
            SkeletonLine(width: AppTheme.spacing.huge, height: AppTheme.spacing.huge, cornerRadius: AppTheme.radius.full)
            VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
              SkeletonLine(width: 120, height: AppTheme.spacing.sm)
              SkeletonLine(width: 80, height: AppTheme.spacing.xs)
            }
          }
          SkeletonLine(height: AppTheme.spacing.sm)
          SkeletonLine(width: 200, height: AppTheme.spacing.sm)
        }
        .padding(AppTheme.spacing.md)
        .background(AppTheme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large))
        .overlay(
          RoundedRectangle(cornerRadius: AppTheme.radius.large)
            .stroke(AppTheme.colors.border, lineWidth: 1)
        )
      }
    }
    .padding(AppTheme.spacing.md)
    .accessibilityLabel("読み込み中")
  }
}

private struct SkeletonLine: View {
  var width: CGFloat? = nil
  var height: CGFloat = AppTheme.spacing.sm
  var cornerRadius: CGFloat = AppTheme.radius.small

  @State private var isAnimating = false

  var body: some View {
    RoundedRectangle(cornerRadius: cornerRadius)
      .fill(AppTheme.colors.border.opacity(isAnimating ? 0.35 : 0.15))
      .frame(width: width, height: height)
      .frame(maxWidth: width == nil ? .infinity : nil, alignment: .leading)
      .onAppear {
        withAnimation(
          .easeInOut(duration: AppTheme.animation.duration.normalSeconds)
          .repeatForever(autoreverses: true)
        ) {
          isAnimating = true
        }
      }
  }
}

#Preview("Spinner") {
  LoadingView(message: "読み込み中...")
    .background(AppTheme.colors.background)
}

#Preview("Skeleton") {
  LoadingView(style: .skeleton)
    .background(AppTheme.colors.background)
}
