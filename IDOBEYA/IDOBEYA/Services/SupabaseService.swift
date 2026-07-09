import Foundation
import Supabase

@MainActor
final class SupabaseService: ObservableObject {
    static let shared = SupabaseService()

    let client: SupabaseClient
    @Published private(set) var currentUserId: UUID?
    @Published private(set) var currentProfile: Profile?

    private init() {
        client = SupabaseClient(
            supabaseURL: AppConfig.supabaseURL,
            supabaseKey: AppConfig.supabaseAnonKey,
            options: .init(
                auth: .init(emitLocalSessionAsInitialSession: true)
            )
        )
        Task { await restoreSession() }
    }

    var isAuthenticated: Bool { currentUserId != nil }

    func restoreSession() async {
        do {
            let session = try await client.auth.session
            if session.isExpired {
                try? await client.auth.signOut()
                currentUserId = nil
                currentProfile = nil
                return
            }
            currentUserId = session.user.id
            try await loadProfile()
        } catch {
            currentUserId = nil
            currentProfile = nil
        }
    }

    func signUp(email: String, password: String, displayName: String) async throws {
        guard AppConfig.isConfigured else { throw AppError.notConfigured }

        _ = try await client.auth.signUp(
            email: email,
            password: password,
            data: ["display_name": .string(displayName)]
        )
        try await signIn(email: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        guard AppConfig.isConfigured else { throw AppError.notConfigured }

        let session = try await client.auth.signIn(email: email, password: password)
        currentUserId = session.user.id
        try await loadProfile()
    }

    func signOut() async throws {
        try await client.auth.signOut()
        currentUserId = nil
        currentProfile = nil
    }

    func loadProfile() async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let profile: Profile = try await client
            .from("profiles")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()
            .value

        currentProfile = profile

        if profile.accountStatus != .active {
            try await signOut()
            throw AppError.validation("このアカウントは利用できません。")
        }
    }

    func updateProfile(displayName: String) async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        try await client
            .from("profiles")
            .update(["display_name": displayName])
            .eq("id", value: userId.uuidString)
            .execute()

        try await loadProfile()
    }

    // MARK: - Rooms

    func fetchPublicRooms(sortByNewest: Bool = true) async throws -> [Room] {
        let base = client
            .from("rooms")
            .select()
            .eq("visibility", value: RoomVisibility.public.rawValue)
            .eq("status", value: RoomStatus.active.rawValue)

        if sortByNewest {
            return try await base
                .order("created_at", ascending: false)
                .execute()
                .value
        } else {
            return try await base
                .order("member_count", ascending: false)
                .execute()
                .value
        }
    }

    func fetchMyRooms() async throws -> [Room] {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let members: [RoomMember] = try await client
            .from("room_members")
            .select()
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value

        let roomIds = members.map(\.roomId.uuidString)
        guard !roomIds.isEmpty else { return [] }

        return try await client
            .from("rooms")
            .select()
            .in("id", values: roomIds)
            .eq("status", value: RoomStatus.active.rawValue)
            .order("updated_at", ascending: false)
            .execute()
            .value
    }

    func fetchRoom(id: UUID) async throws -> Room {
        try await client
            .from("rooms")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
    }

    func createRoom(
        name: String,
        description: String,
        visibility: RoomVisibility,
        category: String?,
        displayName: String
    ) async throws -> Room {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let inviteCode: String? = visibility == .inviteOnly
            ? UUID().uuidString.prefix(8).uppercased()
            : nil

        let insert = RoomInsert(
            name: name,
            description: description,
            visibility: visibility,
            creatorId: userId,
            inviteCode: inviteCode.map { String($0) },
            category: category
        )

        let room: Room = try await client
            .from("rooms")
            .insert(insert)
            .select()
            .single()
            .execute()
            .value

        let member = RoomMemberInsert(roomId: room.id, userId: userId, roomDisplayName: displayName)
        try await client.from("room_members").insert(member).execute()

        return room
    }

    func joinRoom(roomId: UUID, displayName: String) async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let member = RoomMemberInsert(roomId: roomId, userId: userId, roomDisplayName: displayName)
        try await client.from("room_members").insert(member).execute()
    }

    func joinRoomByInviteCode(_ code: String, displayName: String) async throws -> Room {
        let room: Room = try await client
            .from("rooms")
            .select()
            .eq("invite_code", value: code.uppercased())
            .eq("visibility", value: RoomVisibility.inviteOnly.rawValue)
            .single()
            .execute()
            .value

        try await joinRoom(roomId: room.id, displayName: displayName)
        return room
    }

    func leaveRoom(roomId: UUID) async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        try await client
            .from("room_members")
            .delete()
            .eq("room_id", value: roomId.uuidString)
            .eq("user_id", value: userId.uuidString)
            .execute()
    }

    func fetchMembership(roomId: UUID) async throws -> RoomMember? {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let members: [RoomMember] = try await client
            .from("room_members")
            .select()
            .eq("room_id", value: roomId.uuidString)
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value

        return members.first
    }

    func updateRoomDisplayName(roomId: UUID, displayName: String) async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        try await client
            .from("room_members")
            .update(["room_display_name": displayName])
            .eq("room_id", value: roomId.uuidString)
            .eq("user_id", value: userId.uuidString)
            .execute()
    }

    func fetchRoomMembers(roomId: UUID) async throws -> [RoomMember] {
        try await client
            .from("room_members")
            .select()
            .eq("room_id", value: roomId.uuidString)
            .order("joined_at", ascending: true)
            .execute()
            .value
    }

    func updateRoom(
        roomId: UUID,
        name: String,
        description: String,
        category: String?
    ) async throws -> Room {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let room = try await fetchRoom(id: roomId)
        guard room.creatorId == userId || currentProfile?.isAdmin == true else {
            throw AppError.permissionDenied
        }

        let update = RoomUpdate(
            name: name,
            description: description,
            category: category
        )

        return try await client
            .from("rooms")
            .update(update)
            .eq("id", value: roomId.uuidString)
            .select()
            .single()
            .execute()
            .value
    }

    func fetchProfiles(ids: [UUID]) async throws -> [Profile] {
        guard !ids.isEmpty else { return [] }

        return try await client
            .from("profiles")
            .select()
            .in("id", values: ids.map(\.uuidString))
            .execute()
            .value
    }

    // MARK: - Threads

    func fetchThreads(roomId: UUID) async throws -> [Thread] {
        try await client
            .from("threads")
            .select()
            .eq("room_id", value: roomId.uuidString)
            .eq("is_deleted", value: false)
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func createThread(roomId: UUID, title: String, body: String, displayName: String) async throws -> Thread {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let insert = ThreadInsert(
            roomId: roomId,
            userId: userId,
            roomDisplayName: displayName,
            title: title,
            body: body
        )

        return try await client
            .from("threads")
            .insert(insert)
            .select()
            .single()
            .execute()
            .value
    }

    func fetchThreadReplies(threadId: UUID) async throws -> [ThreadReply] {
        try await client
            .from("thread_replies")
            .select()
            .eq("thread_id", value: threadId.uuidString)
            .eq("is_deleted", value: false)
            .order("created_at", ascending: true)
            .execute()
            .value
    }

    func createThreadReply(
        threadId: UUID,
        roomId: UUID,
        body: String,
        displayName: String
    ) async throws -> ThreadReply {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let insert = ThreadReplyInsert(
            threadId: threadId,
            roomId: roomId,
            userId: userId,
            roomDisplayName: displayName,
            body: body
        )

        return try await client
            .from("thread_replies")
            .insert(insert)
            .select()
            .single()
            .execute()
            .value
    }

    func deleteThread(threadId: UUID) async throws {
        try await client
            .from("threads")
            .update(["is_deleted": true])
            .eq("id", value: threadId.uuidString)
            .execute()
    }

    func deleteThreadReply(_ replyId: UUID) async throws {
        try await client
            .from("thread_replies")
            .update(["is_deleted": true])
            .eq("id", value: replyId.uuidString)
            .execute()
    }

    // MARK: - Chat

    func fetchChatMessages(roomId: UUID) async throws -> [ChatMessage] {
        try await client
            .from("chat_messages")
            .select()
            .eq("room_id", value: roomId.uuidString)
            .eq("is_deleted", value: false)
            .order("created_at", ascending: true)
            .execute()
            .value
    }

    func sendChatMessage(roomId: UUID, body: String, displayName: String) async throws -> ChatMessage {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let insert = ChatMessageInsert(
            roomId: roomId,
            userId: userId,
            roomDisplayName: displayName,
            body: body
        )

        return try await client
            .from("chat_messages")
            .insert(insert)
            .select()
            .single()
            .execute()
            .value
    }

    func deleteChatMessage(_ messageId: UUID) async throws {
        try await client
            .from("chat_messages")
            .update(["is_deleted": true])
            .eq("id", value: messageId.uuidString)
            .execute()
    }

    func subscribeToChat(roomId: UUID, onMessage: @escaping (ChatMessage) -> Void) -> Task<Void, Never> {
        Task {
            let channel = client.channel("room:\(roomId.uuidString)")
            let changes = channel.postgresChange(
                InsertAction.self,
                schema: "public",
                table: "chat_messages",
                filter: "room_id=eq.\(roomId.uuidString)"
            )

            await channel.subscribe()

            for await change in changes {
                if let message = try? change.decodeRecord(as: ChatMessage.self, decoder: JSONDecoder.supabase) {
                    onMessage(message)
                }
            }
        }
    }

    // MARK: - Safety

    func submitReport(
        targetType: ReportTargetType,
        reason: String,
        targetUserId: UUID? = nil,
        targetRoomId: UUID? = nil,
        targetThreadId: UUID? = nil,
        targetReplyId: UUID? = nil,
        targetMessageId: UUID? = nil
    ) async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let insert = ReportInsert(
            reporterId: userId,
            targetType: targetType,
            targetUserId: targetUserId,
            targetRoomId: targetRoomId,
            targetThreadId: targetThreadId,
            targetReplyId: targetReplyId,
            targetMessageId: targetMessageId,
            reason: reason
        )

        try await client.from("reports").insert(insert).execute()
    }

    func blockUser(_ blockedId: UUID) async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }
        guard userId != blockedId else { return }

        let insert = BlockInsert(blockerId: userId, blockedId: blockedId)
        try await client.from("blocks").insert(insert).execute()
    }

    func fetchBlockedUserIds() async throws -> Set<UUID> {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let blocks: [Block] = try await client
            .from("blocks")
            .select()
            .eq("blocker_id", value: userId.uuidString)
            .execute()
            .value

        return Set(blocks.map(\.blockedId))
    }

    func unblockUser(_ blockedId: UUID) async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        try await client
            .from("blocks")
            .delete()
            .eq("blocker_id", value: userId.uuidString)
            .eq("blocked_id", value: blockedId.uuidString)
            .execute()
    }

    func muteUser(_ mutedId: UUID) async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }
        guard userId != mutedId else { return }

        let insert = MuteInsert(muterId: userId, mutedId: mutedId)
        try await client.from("mutes").insert(insert).execute()
    }

    func fetchMutedUserIds() async throws -> Set<UUID> {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        let mutes: [Mute] = try await client
            .from("mutes")
            .select()
            .eq("muter_id", value: userId.uuidString)
            .execute()
            .value

        return Set(mutes.map(\.mutedId))
    }

    func unmuteUser(_ mutedId: UUID) async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        try await client
            .from("mutes")
            .delete()
            .eq("muter_id", value: userId.uuidString)
            .eq("muted_id", value: mutedId.uuidString)
            .execute()
    }

    func deleteAccount() async throws {
        guard let userId = currentUserId else { throw AppError.notAuthenticated }

        try await client
            .from("profiles")
            .update(["account_status": AccountStatus.deleted.rawValue])
            .eq("id", value: userId.uuidString)
            .execute()

        try await signOut()
    }

    // MARK: - Admin

    func fetchPendingReports() async throws -> [Report] {
        guard currentProfile?.isAdmin == true else { throw AppError.permissionDenied }

        return try await client
            .from("reports")
            .select()
            .eq("status", value: ReportStatus.pending.rawValue)
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func suspendRoom(_ roomId: UUID) async throws {
        guard currentProfile?.isAdmin == true else { throw AppError.permissionDenied }

        try await client
            .from("rooms")
            .update(["status": RoomStatus.suspended.rawValue])
            .eq("id", value: roomId.uuidString)
            .execute()
    }

    func suspendUser(_ userId: UUID) async throws {
        guard currentProfile?.isAdmin == true else { throw AppError.permissionDenied }

        try await client
            .from("profiles")
            .update(["account_status": AccountStatus.suspended.rawValue])
            .eq("id", value: userId.uuidString)
            .execute()
    }

    func resolveReport(_ reportId: UUID, note: String?) async throws {
        guard currentProfile?.isAdmin == true else { throw AppError.permissionDenied }

        var payload: [String: AnyJSON] = [
            "status": .string(ReportStatus.resolved.rawValue),
            "resolved_at": .string(ISO8601DateFormatter().string(from: Date()))
        ]
        if let note { payload["admin_note"] = .string(note) }

        try await client
            .from("reports")
            .update(payload)
            .eq("id", value: reportId.uuidString)
            .execute()
    }

    func adminDeleteThread(_ threadId: UUID) async throws {
        guard currentProfile?.isAdmin == true else { throw AppError.permissionDenied }
        try await deleteThread(threadId: threadId)
    }

    func adminDeleteReply(_ replyId: UUID) async throws {
        guard currentProfile?.isAdmin == true else { throw AppError.permissionDenied }
        try await deleteThreadReply(replyId)
    }

    func adminDeleteMessage(_ messageId: UUID) async throws {
        guard currentProfile?.isAdmin == true else { throw AppError.permissionDenied }
        try await deleteChatMessage(messageId)
    }
}

private extension JSONDecoder {
    static let supabase: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: string) { return date }
            formatter.formatOptions = [.withInternetDateTime]
            if let date = formatter.date(from: string) { return date }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
        }
        return decoder
    }()
}
