import SwiftUI

struct RoomDetailView: View {
    @EnvironmentObject private var supabase: SupabaseService

    let room: Room

    @State private var displayedRoom: Room
    @State private var membership: RoomMember?
    @State private var isLoading = true
    @State private var joinDisplayName = ""
    @State private var showJoinSheet = false
    @State private var showReportSheet = false
    @State private var errorMessage: String?
    @State private var navigateToRoom = false

    private var isMember: Bool { membership != nil }
    private var isCreator: Bool {
        supabase.currentUserId == displayedRoom.creatorId
    }

    init(room: Room) {
        self.room = room
        _displayedRoom = State(initialValue: room)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerCard
                infoSection
                actionButtons
            }
            .padding()
        }
        .navigationTitle(displayedRoom.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("部屋を通報", systemImage: "exclamationmark.bubble") {
                        showReportSheet = true
                    }
                    if isMember {
                        Button("部屋を退出", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive) {
                            Task { await leaveRoom() }
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showJoinSheet) { joinSheet }
        .sheet(isPresented: $showReportSheet) {
            ReportSheet(
                targetType: .room,
                targetRoomId: displayedRoom.id,
                title: "部屋を通報"
            )
        }
        .navigationDestination(isPresented: $navigateToRoom) {
            roomContentView
        }
        .task { await loadMembership() }
        .overlay {
            if isLoading { ProgressView() }
        }
    }

    @ViewBuilder
    private var roomContentView: some View {
        switch displayedRoom.visibility {
        case .public:
            ThreadListView(room: displayedRoom, membership: membership!)
        case .inviteOnly, .private:
            ChatView(room: displayedRoom, membership: membership!)
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(displayedRoom.visibility.label, systemImage: displayedRoom.visibility.icon)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.indigo)

            if !displayedRoom.description.isEmpty {
                Text(displayedRoom.description)
                    .font(.body)
            }

            HStack {
                Label("\(displayedRoom.memberCount)人参加", systemImage: "person.2.fill")
                Spacer()
                Text(displayedRoom.createdAt, style: .date)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("この部屋について")
                .font(.headline)
            Text(displayedRoom.visibility.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        if let errorMessage {
            ErrorBanner(message: errorMessage)
        }

        if isMember {
            Button {
                navigateToRoom = true
            } label: {
                Label("部屋に入る", systemImage: "arrow.right.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)

            NavigationLink {
                RoomDisplayNameSettingsView(room: displayedRoom, currentName: membership?.roomDisplayName ?? "")
            } label: {
                Label("部屋内の表示名を変更", systemImage: "person.text.rectangle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            if isCreator {
                NavigationLink {
                    RoomEditView(room: displayedRoom) { updated in
                        displayedRoom = updated
                    }
                } label: {
                    Label("部屋情報を編集", systemImage: "pencil")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        } else if displayedRoom.visibility == .public {
            Button {
                joinDisplayName = supabase.currentProfile?.displayName ?? ""
                showJoinSheet = true
            } label: {
                Label("この部屋に参加", systemImage: "person.badge.plus")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
        } else {
            Text("この部屋は招待制または非公開です。招待コードが必要です。")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private var joinSheet: some View {
        NavigationStack {
            Form {
                Section("部屋内の表示名") {
                    TextField("この部屋での表示名", text: $joinDisplayName)
                    Text("部屋ごとに異なる表示名を設定できます")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("参加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { showJoinSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("参加") {
                        Task { await joinRoom() }
                    }
                    .disabled(joinDisplayName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func loadMembership() async {
        isLoading = true
        defer { isLoading = false }
        do {
            membership = try await supabase.fetchMembership(roomId: displayedRoom.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func joinRoom() async {
        do {
            try await supabase.joinRoom(
                roomId: displayedRoom.id,
                displayName: joinDisplayName.trimmingCharacters(in: .whitespaces)
            )
            showJoinSheet = false
            await loadMembership()
            navigateToRoom = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func leaveRoom() async {
        do {
            try await supabase.leaveRoom(roomId: displayedRoom.id)
            membership = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
