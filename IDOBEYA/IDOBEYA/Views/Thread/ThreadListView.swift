import SwiftUI

struct ThreadListView: View {
    @EnvironmentObject private var supabase: SupabaseService

    let room: Room
    let membership: RoomMember

    @State private var threads: [Thread] = []
    @State private var blockedIds: Set<UUID> = []
    @State private var mutedIds: Set<UUID> = []
    @State private var showNewThread = false
    @State private var isLoading = true
    @State private var errorMessage: String?

    private var visibleThreads: [Thread] {
        threads.filter { !blockedIds.contains($0.userId) && !mutedIds.contains($0.userId) }
    }

    var body: some View {
        Group {
            if isLoading && threads.isEmpty {
                ProgressView()
            } else if visibleThreads.isEmpty {
                ContentUnavailableView(
                    "スレッドがありません",
                    systemImage: "text.bubble",
                    description: Text("最初のスレッドを作成しましょう")
                )
            } else {
                List(visibleThreads) { thread in
                    NavigationLink(value: thread) {
                        ThreadRowView(thread: thread)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(room.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showNewThread = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $showNewThread) {
            NewThreadSheet(room: room, displayName: membership.roomDisplayName) {
                await load()
            }
        }
        .navigationDestination(for: Thread.self) { thread in
            ThreadDetailView(room: room, thread: thread, membership: membership)
        }
        .refreshable { await load() }
        .task { await load() }
        .overlay(alignment: .top) {
            if let errorMessage {
                ErrorBanner(message: errorMessage).padding()
            }
        }
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let threadsTask = supabase.fetchThreads(roomId: room.id)
            async let blocksTask = supabase.fetchBlockedUserIds()
            async let mutesTask = supabase.fetchMutedUserIds()
            threads = try await threadsTask
            blockedIds = try await blocksTask
            mutedIds = try await mutesTask
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ThreadRowView: View {
    let thread: Thread

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(thread.title)
                .font(.headline)
                .lineLimit(2)

            if !thread.body.isEmpty {
                Text(thread.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack {
                Text(thread.roomDisplayName)
                Text("·")
                Text(thread.createdAt, style: .relative)
                Spacer()
                Label("\(thread.replyCount)", systemImage: "bubble.right")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct NewThreadSheet: View {
    @EnvironmentObject private var supabase: SupabaseService
    @Environment(\.dismiss) private var dismiss

    let room: Room
    let displayName: String
    let onCreated: () async -> Void

    @State private var title = ""
    @State private var threadBody = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("タイトル", text: $title)
                    TextField("本文", text: $threadBody, axis: .vertical)
                        .lineLimit(4...10)
                }

                if let errorMessage {
                    Text(errorMessage).foregroundStyle(.red)
                }
            }
            .navigationTitle("新規スレッド")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("投稿") { submit() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                }
            }
        }
    }

    private func submit() {
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                _ = try await supabase.createThread(
                    roomId: room.id,
                    title: title.trimmingCharacters(in: .whitespaces),
                    body: threadBody.trimmingCharacters(in: .whitespaces),
                    displayName: displayName
                )
                await onCreated()
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
