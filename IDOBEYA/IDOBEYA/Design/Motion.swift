import SwiftUI

enum Motion {
  static func pressAnimation(reduceMotion: Bool) -> SwiftUI.Animation? {
    reduceMotion
      ? nil
      : .spring(response: Theme.Animation.springResponse, dampingFraction: Theme.Animation.springDamping)
  }

  static func standard(reduceMotion: Bool) -> SwiftUI.Animation? {
    reduceMotion
      ? nil
      : .spring(response: Theme.Animation.springResponse, dampingFraction: Theme.Animation.springDamping)
  }

  static func selection<Value: Equatable>(reduceMotion: Bool, value: Value) -> SwiftUI.Animation? {
    standard(reduceMotion: reduceMotion)
  }
}

extension View {
  func idoMotion<Value: Equatable>(_ value: Value, reduceMotion: Bool) -> some View {
    animation(Motion.standard(reduceMotion: reduceMotion), value: value)
  }
}
