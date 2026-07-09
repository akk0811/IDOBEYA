import Foundation

enum RoomVisibility: String, Codable, CaseIterable, Identifiable {
    case `public` = "public"
    case inviteOnly = "invite_only"
    case `private` = "private"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .public: return "公開部屋"
        case .inviteOnly: return "招待制部屋"
        case .private: return "非公開部屋"
        }
    }

    var subtitle: String {
        switch self {
        case .public: return "誰でも参加・スレッド形式"
        case .inviteOnly: return "招待された人のみ・チャット形式"
        case .private: return "自分だけまたは限定・チャット形式"
        }
    }

    var icon: String {
        switch self {
        case .public: return "globe"
        case .inviteOnly: return "envelope"
        case .private: return "lock"
        }
    }
}

enum RoomStatus: String, Codable {
    case active, suspended, deleted
}

enum AccountStatus: String, Codable {
    case active, suspended, deleted
}

enum ReportTargetType: String, Codable, CaseIterable {
    case user, post, thread, message, room

    var label: String {
        switch self {
        case .user: return "ユーザー"
        case .post: return "投稿"
        case .thread: return "スレッド"
        case .message: return "メッセージ"
        case .room: return "部屋"
        }
    }
}

enum ReportStatus: String, Codable {
    case pending, reviewing, resolved, dismissed
}
