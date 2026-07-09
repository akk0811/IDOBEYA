import SwiftUI

// MARK: - Theme (Single source of truth)

enum Theme {

  // MARK: Color (Light / Dark adaptive)

  enum Color {
    static let background = adaptive(light: hex("FAF8F5"), dark: hex("1C1B19"))
    static let surface = adaptive(light: hex("FFFFFF"), dark: hex("2A2826"))
    static let primary = adaptive(light: hex("5F8D6B"), dark: hex("7CAD88"))
    static let primaryDark = adaptive(light: hex("4D7358"), dark: hex("5F8D6B"))
    static let accent = adaptive(light: hex("D97706"), dark: hex("F59E0B"))
    static let text = adaptive(light: hex("333333"), dark: hex("F5F3F0"))
    static let textSecondary = adaptive(light: hex("777777"), dark: hex("A8A29E"))
    static let border = adaptive(light: hex("E8E1D8"), dark: hex("3D3A36"))
    static let danger = adaptive(light: hex("D9534F"), dark: hex("E57373"))
    static let onPrimary = adaptive(light: hex("FFFFFF"), dark: hex("1C1B19"))
    static let onDanger = adaptive(light: hex("FFFFFF"), dark: hex("1C1B19"))
    static let scrim = adaptive(light: hex("000000"), dark: hex("000000"))
    static var overlay: SwiftUI.Color { scrim.opacity(0.6) }
    static var shadow: SwiftUI.Color { scrim.opacity(0.06) }
    static var imagePlaceholder: SwiftUI.Color { primary.opacity(0.1) }
    static var unreadBackground: SwiftUI.Color { primary.opacity(0.08) }
    static let selectedChipForeground = onPrimary
    static var iconOnScrim: SwiftUI.Color { onPrimary.opacity(0.9) }
    static var iconOnScrimMuted: SwiftUI.Color { onPrimary.opacity(0.65) }
    static var elevatedSurface: SwiftUI.Color { surface }
    static var groupedBackground: SwiftUI.Color { background }

    private static func hex(_ value: String) -> SwiftUI.Color {
      SwiftUI.Color(hex: value)
    }

    private static func adaptive(light: SwiftUI.Color, dark: SwiftUI.Color) -> SwiftUI.Color {
      SwiftUI.Color(
        uiColor: UIColor { traits in
          traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        }
      )
    }
  }

  // MARK: Spacing (8pt grid)

  enum Spacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let screen: CGFloat = 20
    /// 片手操作：親指が届きやすい下部余白
    static let thumbClearance: CGFloat = 24
    /// HIG 最小タップ領域
    static let minTapTarget: CGFloat = 44
  }

  // MARK: FontSize (Dynamic Type 基準)

  enum FontSize {
    static let caption: Font.TextStyle = .caption
    static let body: Font.TextStyle = .subheadline
    static let heading: Font.TextStyle = .headline
    static let title: Font.TextStyle = .title3
    static let brand: Font.TextStyle = .title
    static let largeTitle: Font.TextStyle = .largeTitle
  }

  // MARK: IconSize (scales with Dynamic Type where noted)

  enum IconSize {
    static let avatarSm: CGFloat = 32
    static let avatarMd: CGFloat = 36
    static let avatarLg: CGFloat = 44
    static let avatarXl: CGFloat = 72
    static let brand: CGFloat = 80
    static let notification: CGFloat = 40
    static let empty: CGFloat = 36
  }

  // MARK: Radius

  enum Radius {
    static let sm: CGFloat = 10
    static let md: CGFloat = 12
    static let card: CGFloat = 16
    static let pill: CGFloat = 999
  }

  // MARK: Animation

  enum Animation {
    static let fast: Double = 0.2
    static let standard: Double = 0.3
    static let springResponse: Double = 0.35
    static let springDamping: Double = 0.86
  }
}

// MARK: - Typography (Dynamic Type)

enum IDOFont {
  static func body(_ weight: Font.Weight = .regular) -> Font {
    .system(Theme.FontSize.body, design: .default, weight: weight)
  }

  static func heading(_ weight: Font.Weight = .semibold) -> Font {
    .system(Theme.FontSize.heading, design: .default, weight: weight)
  }

  static func title(_ weight: Font.Weight = .bold) -> Font {
    .system(Theme.FontSize.title, design: .default, weight: weight)
  }

  static func caption(_ weight: Font.Weight = .regular) -> Font {
    .system(Theme.FontSize.caption, design: .default, weight: weight)
  }

  static func brand(_ weight: Font.Weight = .bold) -> Font {
    .system(Theme.FontSize.brand, design: .default, weight: weight)
  }

  static func largeTitle(_ weight: Font.Weight = .bold) -> Font {
    .system(Theme.FontSize.largeTitle, design: .default, weight: weight)
  }
}

// MARK: - Legacy bridge

enum IDOTheme {
  static let background = Theme.Color.background
  static let card = Theme.Color.surface
  static let primary = Theme.Color.primary
  static let primaryDark = Theme.Color.primaryDark
  static let accent = Theme.Color.accent
  static let text = Theme.Color.text
  static let textSecondary = Theme.Color.textSecondary
  static let border = Theme.Color.border
  static let danger = Theme.Color.danger
  static let cardRadius = Theme.Radius.card
  static let buttonRadius = Theme.Radius.pill
  static let spacing = Theme.Spacing.lg
  static let padding = Theme.Spacing.screen
  static let cardShadow = Theme.Color.shadow
  static let animationDuration = Theme.Animation.standard
}

// MARK: - Color hex

extension SwiftUI.Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let r = Double((int >> 16) & 0xFF) / 255
    let g = Double((int >> 8) & 0xFF) / 255
    let b = Double(int & 0xFF) / 255
    self.init(red: r, green: g, blue: b)
  }
}

// MARK: - View modifiers

extension View {
  func idoScreenBackground() -> some View {
    background(Theme.Color.background.ignoresSafeArea())
  }
}

struct IDOPressButtonStyle: ButtonStyle {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.97 : 1)
      .animation(Motion.pressAnimation(reduceMotion: reduceMotion), value: configuration.isPressed)
  }
}
