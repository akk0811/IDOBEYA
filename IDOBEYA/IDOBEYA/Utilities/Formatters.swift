import Foundation

enum GreetingFormatter {
  static func current() -> String {
    let hour = Calendar.current.component(.hour, from: Date())
    switch hour {
    case 5..<11: return "おはようございます"
    case 11..<17: return "こんにちは"
    default: return "こんばんは"
    }
  }
}

enum TextValidator {
  static func isNotEmpty(_ text: String) -> Bool {
    !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  static func isValidPassword(_ password: String, minimum: Int = 6) -> Bool {
    password.count >= minimum
  }
}
