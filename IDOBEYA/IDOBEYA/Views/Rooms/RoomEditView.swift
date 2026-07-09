import SwiftUI

struct RoomEditView: View {
    @EnvironmentObject private var supabase: SupabaseService
    @Environment(\.dismiss) private var dismiss

    let room: Room
    let onUpdated: (Room) -> Void

    @State private var name: String
    @State private var description: String
    @State private var category: String
    @State private var isSaving = false
    @State private var errorMessage: String?

    init(room: Room, onUpdated: @escaping (Room) -> Void) {
        self.room = room
        self.onUpdated = onUpdated
        _name = State(initialValue: room.name)
        _description = State(initialValue: room.description)
        _category = State(initialValue: room.category ?? "")
    }

    var body: some View {
        Form {
            Section("部屋情報") {
                TextField("部屋名", text: $name)
                TextField("説明", text: $description, axis: .vertical)
                    .lineLimit(3...6)
                TextField("カテゴリ（任意）", text: $category)
            }

            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            }
        }
        .navigationTitle("部屋を編集")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("保存") { Task { await save() } }
                    .disabled(isSaving || name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    private func save() async {
        isSaving = true
        errorMessage = nil
        defer { isSaving = false }

        do {
            let updated = try await supabase.updateRoom(
                roomId: room.id,
                name: name.trimmingCharacters(in: .whitespaces),
                description: description.trimmingCharacters(in: .whitespaces),
                category: category.isEmpty ? nil : category
            )
            onUpdated(updated)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
