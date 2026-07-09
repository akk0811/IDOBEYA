import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var supabase: SupabaseService

    let room: Room
    let membership: RoomMember

    @State private var messages: [ChatMessage] = []
    @State private var blockedIds: Set<UUID> = []
    @State private var mutedIds: Set<UUID> = []
    @State private var messageText = ""
    @State private var reportMessage: ChatMessage?
    @State private var realtimeTask: Task<Void, Never>?
    @State private var isLoading = true
    @State private var errorMessage: String?

    private var visibleMessages: [ChatMessage] {
        messages.filter { !blockedIds.contains($0.userId) && !mutedIds.contains($0.userId) }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        if visibleMessages.isEmpty && !isLoading {
                            Text("メッセージを送って会話を始めましょう")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.top, 40)
                        }

                        ForEach(visibleMessages) { message in
                            ChatBubbleView(
                                message: message,
                                isOwn: message.userId == supabase.currentUserId,
                                onReport: { reportMessage = message },
                                onBlock: { Task { await blockUser(message.userId) } },
                                onMute: { Task { await muteUser(message.userId) } },
                                onDelete: { Task { await deleteMessage(message) } }
                            )
                            .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _, _ in
                    if let last = visibleMessages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            messageInputBar
        }
        .navigationTitle(room.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    RoomMembersView(room: room)
                } label: {
                    Image(systemName: "person.2")
                }
            }
        }
        .sheet(item: $reportMessage) { message in
            ReportSheet(
                targetType: .message,
                targetUserId: message.userId,
                targetMessageId: message.id,
                title: "メッセージを通報"
            )
        }
        .task {
            await load()
            startRealtime()
        }
        .onDisappear {
            realtimeTask?.cancel()
        }
    }

    private var messageInputBar: some View {
        HStack(spacing: 12) {
            TextField("メッセージ...", text: $messageText, axis: .vertical)
                .lineLimit(1...4)
                .padding(10)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Button {
                Task { await sendMessage() }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(messageText.isEmpty ? .gray : .indigo)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(.bar)
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            async let messagesTask = supabase.fetchChatMessages(roomId: room.id)
            async let blocksTask = supabase.fetchBlockedUserIds()
            async let mutesTask = supabase.fetchMutedUserIds()
            messages = try await messagesTask
            blockedIds = try await blocksTask
            mutedIds = try await mutesTask
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func sendMessage() async {
        let text = messageText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        do {
            let message = try await supabase.sendChatMessage(
                roomId: room.id,
                body: text,
                displayName: membership.roomDisplayName
            )
            if !messages.contains(where: { $0.id == message.id }) {
                messages.append(message)
            }
            messageText = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func startRealtime() {
        realtimeTask = supabase.subscribeToChat(roomId: room.id) { message in
            if !messages.contains(where: { $0.id == message.id }) {
                messages.append(message)
            }
        }
    }

    private func deleteMessage(_ message: ChatMessage) async {
        do {
            try await supabase.deleteChatMessage(message.id)
            messages.removeAll { $0.id == message.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func blockUser(_ userId: UUID) async {
        do {
            try await supabase.blockUser(userId)
            blockedIds.insert(userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func muteUser(_ userId: UUID) async {
        do {
            try await supabase.muteUser(userId)
            mutedIds.insert(userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ChatBubbleView: View {
    let message: ChatMessage
    let isOwn: Bool
    let onReport: () -> Void
    let onBlock: () -> Void
    let onMute: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack {
            if isOwn { Spacer(minLength: 48) }

            VStack(alignment: isOwn ? .trailing : .leading, spacing: 4) {
                if !isOwn {
                    Text(message.roomDisplayName)
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                }

                Text(message.body)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isOwn ? Color.indigo : Color(.secondarySystemGroupedBackground))
                    .foregroundStyle(isOwn ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Text(message.createdAt, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .contextMenu {
                if isOwn {
                    Button("削除", systemImage: "trash", role: .destructive) { onDelete() }
                } else {
                    Button("通報", systemImage: "exclamationmark.bubble") { onReport() }
                    Button("ミュート", systemImage: "speaker.slash") { onMute() }
                    Button("ブロック", systemImage: "hand.raised", role: .destructive) { onBlock() }
                }
            }

            if !isOwn { Spacer(minLength: 48) }
        }
    }
}

struct RoomMembersView: View {
    @EnvironmentObject private var supabase: SupabaseService

    let room: Room
    @State private var members: [RoomMember] = []

    var body: some View {
        List(members) { member in
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.indigo)
                VStack(alignment: .leading) {
                    Text(member.roomDisplayName)
                        .font(.headline)
                    Text("参加: \(member.joinedAt, style: .date)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("メンバー")
        .toolbar {
            if room.visibility == .inviteOnly, let inviteCode = room.inviteCode {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: "IDOBEYA 招待コード: \(inviteCode)") {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .task {
            members = (try? await supabase.fetchRoomMembers(roomId: room.id)) ?? []
        }
    }
}
