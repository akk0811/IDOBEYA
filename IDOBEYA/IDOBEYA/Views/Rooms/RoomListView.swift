import SwiftUI

struct RoomListView: View {
    @EnvironmentObject private var supabase: SupabaseService

    @State private var rooms: [Room] = []
    @State private var searchText = ""
    @State private var sortByNewest = true
    @State private var isLoading = true
    @State private var errorMessage: String?

    private var filteredRooms: [Room] {
        guard !searchText.isEmpty else { return rooms }
        return rooms.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText) ||
            ($0.category?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading && rooms.isEmpty {
                    ProgressView()
                } else if filteredRooms.isEmpty {
                    ContentUnavailableView(
                        "部屋が見つかりません",
                        systemImage: "door.left.hand.closed",
                        description: Text(searchText.isEmpty ? "公開部屋がまだありません" : "検索条件に一致する部屋がありません")
                    )
                } else {
                    List(filteredRooms) { room in
                        NavigationLink(value: room) {
                            RoomRowView(room: room, showDescription: true)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("公開部屋")
            .searchable(text: $searchText, prompt: "部屋名・カテゴリで検索")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("新着順") { sortByNewest = true; Task { await load() } }
                        Button("人気順") { sortByNewest = false; Task { await load() } }
                    } label: {
                        Label("並び替え", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .navigationDestination(for: Room.self) { room in
                RoomDetailView(room: room)
            }
            .refreshable { await load() }
            .task { await load() }
            .overlay(alignment: .top) {
                if let errorMessage {
                    ErrorBanner(message: errorMessage)
                        .padding()
                }
            }
        }
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            rooms = try await supabase.fetchPublicRooms(sortByNewest: sortByNewest)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct RoomRowView: View {
    let room: Room
    var showDescription: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: room.visibility.icon)
                .font(.title2)
                .foregroundStyle(.indigo)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(room.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if showDescription, !room.description.isEmpty {
                    Text(room.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 12) {
                    Label("\(room.memberCount)人", systemImage: "person.2")
                    if let category = room.category, !category.isEmpty {
                        Text(category)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.indigo.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
