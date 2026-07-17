import SwiftUI

struct AppToastData: Identifiable, Equatable {
  enum Style: Equatable {
    case success
    case info
    case warning
    case error
  }

  let id = UUID()
  let message: String
  let style: Style
}

struct AppToast: View {
  let data: AppToastData

  var body: some View {
    HStack(spacing: AppTheme.spacing.sm) {
      Image(systemName: iconName)
        .foregroundStyle(tintColor)

      Text(data.message)
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.textPrimary)

      Spacer(minLength: 0)
    }
    .padding(AppTheme.spacing.md)
    .background(AppTheme.colors.surface)
    .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large))
    .overlay(
      RoundedRectangle(cornerRadius: AppTheme.radius.large)
        .stroke(tintColor.opacity(0.2), lineWidth: 1)
    )
    .appShadow(AppTheme.shadow.medium)
    .accessibilityElement(children: .combine)
    .accessibilityLabel(data.message)
  }

  private var iconName: String {
    switch data.style {
    case .success: "checkmark.circle.fill"
    case .info: "info.circle.fill"
    case .warning: "exclamationmark.triangle.fill"
    case .error: "xmark.circle.fill"
    }
  }

  private var tintColor: Color {
    switch data.style {
    case .success: AppTheme.colors.success
    case .info: AppTheme.colors.info
    case .warning: AppTheme.colors.warning
    case .error: AppTheme.colors.error
    }
  }
}

private struct AppToastModifier: ViewModifier {
  @Binding var toast: AppToastData?

  func body(content: Content) -> some View {
    content
      .overlay(alignment: .top) {
        if let toast {
          AppToast(data: toast)
            .padding(.horizontal, AppTheme.spacing.lg)
            .padding(.top, AppTheme.spacing.sm)
            .transition(.move(edge: .top).combined(with: .opacity))
            .allowsHitTesting(false)
            .zIndex(1)
            .task(id: toast.id) {
              try? await Task.sleep(for: .seconds(2.5))
              guard self.toast?.id == toast.id else { return }
              withAnimation(AppTheme.animation.presets.transition.animation) {
                self.toast = nil
              }
            }
        }
      }
      .animation(AppTheme.animation.presets.transition.animation, value: toast)
  }
}

extension View {
  func appToast(_ toast: Binding<AppToastData?>) -> some View {
    modifier(AppToastModifier(toast: toast))
  }
}

#Preview {
  Color.clear
    .appScreenBackground()
    .appToast(
      .constant(
        AppToastData(
          message: "この部屋に参加しました",
          style: .success
        )
      )
    )
}
