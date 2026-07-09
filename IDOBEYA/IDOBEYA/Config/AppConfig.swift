import Foundation

enum AppConfig {
  private static let secrets: [String: Any]? = {
    guard let url = Bundle.main.url(forResource: "SupabaseSecrets", withExtension: "plist"),
          let data = try? Data(contentsOf: url),
          let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]
    else { return nil }
    return plist
  }()

  static var supabaseURL: URL {
    if let value = secrets?["SUPABASE_URL"] as? String,
       let url = URL(string: value),
       !value.isEmpty {
      return url
    }
    if let value = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
       let url = URL(string: value), !value.isEmpty {
      return url
    }
    return URL(string: "https://YOUR_PROJECT.supabase.co")!
  }

  static var supabaseAnonKey: String {
    if let value = secrets?["SUPABASE_ANON_KEY"] as? String, !value.isEmpty {
      return value
    }
    if let value = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
       !value.isEmpty {
      return value
    }
    return "YOUR_SUPABASE_ANON_KEY"
  }

  static var isConfigured: Bool {
    !supabaseAnonKey.contains("YOUR_") &&
    !supabaseURL.absoluteString.contains("YOUR_") &&
    supabaseURL.host?.contains("supabase.co") == true
  }
}

enum AppError: LocalizedError {
  case notConfigured
  case notAuthenticated
  case notFound
  case permissionDenied
  case validation(String)
  case server(String)

  var errorDescription: String? {
    switch self {
    case .notConfigured:
      return "Supabase の設定が完了していません。Resources/SupabaseSecrets.plist を設定してください。"
    case .notAuthenticated:
      return "ログインが必要です。"
    case .notFound:
      return "データが見つかりませんでした。"
    case .permissionDenied:
      return "この操作を行う権限がありません。"
    case .validation(let message):
      return message
    case .server(let message):
      return message
    }
  }
}
