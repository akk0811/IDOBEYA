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
    HStack(alignment: .top, spacing: AppTheme.spacing.sm) {
      Image(systemName: iconName)
        .foregroundStyle(tintColor)
        .accessibilityHidden(true)

      Text(data.message)
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.textPrimary)
        .multilineTextAlignment(.leading)
        .lineLimit(3)
        .fixedSize(horizontal: false, vertical: true)

      Spacer(minLength: 0)
    }
    .padding(AppTheme.spacing.md)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(AppTheme.colors.surface)
    .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large))
    .overlay(
      RoundedRectangle(cornerRadius: AppTheme.radius.large)
        .stroke(tintColor.opacity(0.22), lineWidth: 1)
    )
    .appShadow(AppTheme.shadow.medium)
    .accessibilityElement(children: .combine)
    .accessibilityLabel(data.message)
    .accessibilityAddTraits(.isStaticText)
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
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  func body(content: Content) -> some View {
    content
      .overlay(alignment: .top) {
        if let toast {
          AppToast(data: toast)
            .padding(.horizontal, AppTheme.spacing.lg)
            .padding(.top, AppTheme.spacing.md)
            .transition(toastTransition)
            .allowsHitTesting(false)
            .zIndex(1)
            .onAppear {
              UIAccessibility.post(notification: .announcement, argument: toast.message)
            }
            .task(id: toast.id) {
              try? await Task.sleep(for: .seconds(2.5))
              guard self.toast?.id == toast.id else { return }
              dismissToast()
            }
        }
      }
      .animation(toastAnimation, value: toast)
  }

  private var toastTransition: AnyTransition {
    if reduceMotion {
      return .opacity
    }
    return .move(edge: .top).combined(with: .opacity)
  }

  private var toastAnimation: Animation? {
    reduceMotion ? nil : AppTheme.animation.presets.transition.animation
  }

  private func dismissToast() {
    if reduceMotion {
      toast = nil
    } else {
      withAnimation(AppTheme.animation.presets.transition.animation) {
        toast = nil
      }
    }
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
