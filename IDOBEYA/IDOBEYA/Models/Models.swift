import Foundation

struct Profile: Codable, Identifiable, Hashable {
    let id: UUID
    var email: String?
    var displayName: String
    var accountStatus: AccountStatus
    var isAdmin: Bool
    let createdAt: Date
    var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, email
        case displayName = "display_name"
        case accountStatus = "account_status"
        case isAdmin = "is_admin"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Room: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var visibility: RoomVisibility
    let creatorId: UUID
    var status: RoomStatus
    var inviteCode: String?
    var category: String?
    var memberCount: Int
    var reportCount: Int
    let createdAt: Date
    var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, name, description, visibility, status, category
        case creatorId = "creator_id"
        case inviteCode = "invite_code"
        case memberCount = "member_count"
        case reportCount = "report_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct RoomMember: Codable, Identifiable, Hashable {
    let id: UUID
    let roomId: UUID
    let userId: UUID
    var roomDisplayName: String
    let joinedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case roomId = "room_id"
        case userId = "user_id"
        case roomDisplayName = "room_display_name"
        case joinedAt = "joined_at"
    }
}

struct Thread: Codable, Identifiable, Hashable {
    let id: UUID
    let roomId: UUID
    let userId: UUID
    var roomDisplayName: String
    var title: String
    var body: String
    var replyCount: Int
    var reportCount: Int
    var isDeleted: Bool
    let createdAt: Date
    var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, title, body
        case roomId = "room_id"
        case userId = "user_id"
        case roomDisplayName = "room_display_name"
        case replyCount = "reply_count"
        case reportCount = "report_count"
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ThreadReply: Codable, Identifiable, Hashable {
    let id: UUID
    let threadId: UUID
    let roomId: UUID
    let userId: UUID
    var roomDisplayName: String
    var body: String
    var reportCount: Int
    var isDeleted: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, body
        case threadId = "thread_id"
        case roomId = "room_id"
        case userId = "user_id"
        case roomDisplayName = "room_display_name"
        case reportCount = "report_count"
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
    }
}

struct ChatMessage: Codable, Identifiable, Hashable {
    let id: UUID
    let roomId: UUID
    let userId: UUID
    var roomDisplayName: String
    var body: String
    var reportCount: Int
    var isDeleted: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, body
        case roomId = "room_id"
        case userId = "user_id"
        case roomDisplayName = "room_display_name"
        case reportCount = "report_count"
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
    }
}

struct Block: Codable, Identifiable, Hashable {
    let id: UUID
    let blockerId: UUID
    let blockedId: UUID
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case blockerId = "blocker_id"
        case blockedId = "blocked_id"
        case createdAt = "created_at"
    }
}

struct Mute: Codable, Identifiable, Hashable {
    let id: UUID
    let muterId: UUID
    let mutedId: UUID
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case muterId = "muter_id"
        case mutedId = "muted_id"
        case createdAt = "created_at"
    }
}

struct Report: Codable, Identifiable, Hashable {
    let id: UUID
    let reporterId: UUID
    var targetType: ReportTargetType
    var targetUserId: UUID?
    var targetRoomId: UUID?
    var targetThreadId: UUID?
    var targetReplyId: UUID?
    var targetMessageId: UUID?
    var reason: String
    var status: ReportStatus
    var adminNote: String?
    let createdAt: Date
    var resolvedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, reason, status
        case reporterId = "reporter_id"
        case targetType = "target_type"
        case targetUserId = "target_user_id"
        case targetRoomId = "target_room_id"
        case targetThreadId = "target_thread_id"
        case targetReplyId = "target_reply_id"
        case targetMessageId = "target_message_id"
        case adminNote = "admin_note"
        case createdAt = "created_at"
        case resolvedAt = "resolved_at"
    }
}

// MARK: - Insert DTOs

struct RoomInsert: Encodable {
    let name: String
    let description: String
    let visibility: RoomVisibility
    let creatorId: UUID
    let inviteCode: String?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case name, description, visibility, category
        case creatorId = "creator_id"
        case inviteCode = "invite_code"
    }
}

struct RoomMemberInsert: Encodable {
    let roomId: UUID
    let userId: UUID
    let roomDisplayName: String

    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case userId = "user_id"
        case roomDisplayName = "room_display_name"
    }
}

struct ThreadInsert: Encodable {
    let roomId: UUID
    let userId: UUID
    let roomDisplayName: String
    let title: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case title, body
        case roomId = "room_id"
        case userId = "user_id"
        case roomDisplayName = "room_display_name"
    }
}

struct ThreadReplyInsert: Encodable {
    let threadId: UUID
    let roomId: UUID
    let userId: UUID
    let roomDisplayName: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case body
        case threadId = "thread_id"
        case roomId = "room_id"
        case userId = "user_id"
        case roomDisplayName = "room_display_name"
    }
}

struct ChatMessageInsert: Encodable {
    let roomId: UUID
    let userId: UUID
    let roomDisplayName: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case body
        case roomId = "room_id"
        case userId = "user_id"
        case roomDisplayName = "room_display_name"
    }
}

struct ReportInsert: Encodable {
    let reporterId: UUID
    let targetType: ReportTargetType
    let targetUserId: UUID?
    let targetRoomId: UUID?
    let targetThreadId: UUID?
    let targetReplyId: UUID?
    let targetMessageId: UUID?
    let reason: String

    enum CodingKeys: String, CodingKey {
        case reason
        case reporterId = "reporter_id"
        case targetType = "target_type"
        case targetUserId = "target_user_id"
        case targetRoomId = "target_room_id"
        case targetThreadId = "target_thread_id"
        case targetReplyId = "target_reply_id"
        case targetMessageId = "target_message_id"
    }
}

struct BlockInsert: Encodable {
    let blockerId: UUID
    let blockedId: UUID

    enum CodingKeys: String, CodingKey {
        case blockerId = "blocker_id"
        case blockedId = "blocked_id"
    }
}

struct MuteInsert: Encodable {
    let muterId: UUID
    let mutedId: UUID

    enum CodingKeys: String, CodingKey {
        case muterId = "muter_id"
        case mutedId = "muted_id"
    }
}

struct RoomUpdate: Encodable {
    let name: String
    let description: String
    let category: String?

    enum CodingKeys: String, CodingKey {
        case name, description, category
    }
}
