import SwiftUI

struct ThreadDetailView: View {
    @EnvironmentObject private var supabase: SupabaseService
    @Environment(\.dismiss) private var dismiss

    let room: Room
    let thread: Thread
    let membership: RoomMember

    @State private var replies: [ThreadReply] = []
    @State private var blockedIds: Set<UUID> = []
    @State private var mutedIds: Set<UUID> = []
    @State private var replyText = ""
    @State private var showReportThread = false
    @State private var reportReply: ThreadReply?
    @State private var isLoading = true
    @State private var isDeleted = false
    @State private var errorMessage: String?

    private var visibleReplies: [ThreadReply] {
        replies.filter { !blockedIds.contains($0.userId) && !mutedIds.contains($0.userId) }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    threadHeader

                    Divider()

                    if visibleReplies.isEmpty && !isLoading {
                        Text("まだ返信がありません")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        ForEach(visibleReplies) { reply in
                            ReplyBubbleView(
                                reply: reply,
                                isOwn: reply.userId == supabase.currentUserId,
                                onReport: { reportReply = reply },
                                onBlock: { Task { await blockUser(reply.userId) } },
                                onMute: { Task { await muteUser(reply.userId) } },
                                onDelete: { Task { await deleteReply(reply) } }
                            )
                        }
                    }
                }
                .padding()
            }

            replyInputBar
        }
        .navigationTitle("スレッド")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    if thread.userId == supabase.currentUserId {
                        Button("削除", systemImage: "trash", role: .destructive) {
                            Task { await deleteThread() }
                        }
                    }
                    Button("通報", systemImage: "exclamationmark.bubble") {
                        showReportThread = true
                    }
                    if thread.userId != supabase.currentUserId {
                        Button("ミュート", systemImage: "speaker.slash") {
                            Task { await muteUser(thread.userId) }
                        }
                        Button("ブロック", systemImage: "hand.raised", role: .destructive) {
                            Task { await blockUser(thread.userId) }
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showReportThread) {
            ReportSheet(
                targetType: .thread,
                targetUserId: thread.userId,
                targetThreadId: thread.id,
                title: "スレッドを通報"
            )
        }
        .sheet(item: $reportReply) { reply in
            ReportSheet(
                targetType: .post,
                targetUserId: reply.userId,
                targetReplyId: reply.id,
                title: "返信を通報"
            )
        }
        .onChange(of: isDeleted) { _, deleted in
            if deleted { dismiss() }
        }
        .task { await load() }
    }

    private var threadHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(thread.title)
                .font(.title2.bold())

            if !thread.body.isEmpty {
                Text(thread.body)
                    .font(.body)
            }

            HStack {
                Text(thread.roomDisplayName)
                Text("·")
                Text(thread.createdAt, style: .date)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    private var replyInputBar: some View {
        HStack(spacing: 12) {
            TextField("返信を入力...", text: $replyText, axis: .vertical)
                .lineLimit(1...4)
                .padding(10)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Button {
                Task { await sendReply() }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(replyText.isEmpty ? .gray : .indigo)
            }
            .disabled(replyText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(.bar)
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            async let repliesTask = supabase.fetchThreadReplies(threadId: thread.id)
            async let blocksTask = supabase.fetchBlockedUserIds()
            async let mutesTask = supabase.fetchMutedUserIds()
            replies = try await repliesTask
            blockedIds = try await blocksTask
            mutedIds = try await mutesTask
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func sendReply() async {
        let text = replyText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        do {
            let reply = try await supabase.createThreadReply(
                threadId: thread.id,
                roomId: room.id,
                body: text,
                displayName: membership.roomDisplayName
            )
            replies.append(reply)
            replyText = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteThread() async {
        do {
            try await supabase.deleteThread(threadId: thread.id)
            isDeleted = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteReply(_ reply: ThreadReply) async {
        do {
            try await supabase.deleteThreadReply(reply.id)
            replies.removeAll { $0.id == reply.id }
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

struct ReplyBubbleView: View {
    let reply: ThreadReply
    let isOwn: Bool
    let onReport: () -> Void
    let onBlock: () -> Void
    let onMute: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(reply.roomDisplayName)
                    .font(.caption.bold())
                Text(reply.createdAt, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Menu {
                    if isOwn {
                        Button("削除", systemImage: "trash", role: .destructive) { onDelete() }
                    } else {
                        Button("通報", systemImage: "exclamationmark.bubble") { onReport() }
                        Button("ミュート", systemImage: "speaker.slash") { onMute() }
                        Button("ブロック", systemImage: "hand.raised", role: .destructive) { onBlock() }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Text(reply.body)
                .font(.body)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
