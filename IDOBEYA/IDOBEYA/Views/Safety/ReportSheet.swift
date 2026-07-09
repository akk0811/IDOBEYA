import SwiftUI

struct ReportSheet: View {
    @EnvironmentObject private var supabase: SupabaseService
    @Environment(\.dismiss) private var dismiss

    let targetType: ReportTargetType
    var targetUserId: UUID?
    var targetRoomId: UUID?
    var targetThreadId: UUID?
    var targetReplyId: UUID?
    var targetMessageId: UUID?
    let title: String

    @State private var reason = ""
    @State private var selectedPreset = ""
    @State private var isSubmitting = false
    @State private var submitted = false
    @State private var errorMessage: String?

    private let presets = [
        "スパム・宣伝",
        "誹謗中傷・ハラスメント",
        "不適切な内容",
        "個人情報の投稿",
        "なりすまし",
        "その他"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("通報理由") {
                    Picker("カテゴリ", selection: $selectedPreset) {
                        Text("選択してください").tag("")
                        ForEach(presets, id: \.self) { preset in
                            Text(preset).tag(preset)
                        }
                    }

                    if selectedPreset == "その他" || !selectedPreset.isEmpty {
                        TextField("詳細（任意）", text: $reason, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }

                if submitted {
                    Section {
                        Label("通報を受け付けました。運営が確認します。", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }

                if let errorMessage {
                    Text(errorMessage).foregroundStyle(.red)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(submitted ? "閉じる" : "キャンセル") { dismiss() }
                }
                if !submitted {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("送信") { submit() }
                            .disabled(selectedPreset.isEmpty || isSubmitting)
                    }
                }
            }
        }
    }

    private func submit() {
        let fullReason = reason.isEmpty ? selectedPreset : "\(selectedPreset): \(reason)"
        isSubmitting = true
        Task {
            defer { isSubmitting = false }
            do {
                try await supabase.submitReport(
                    targetType: targetType,
                    reason: fullReason,
                    targetUserId: targetUserId,
                    targetRoomId: targetRoomId,
                    targetThreadId: targetThreadId,
                    targetReplyId: targetReplyId,
                    targetMessageId: targetMessageId
                )
                submitted = true
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct AdminView: View {
    @EnvironmentObject private var supabase: SupabaseService

    @State private var reports: [Report] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if reports.isEmpty {
                ContentUnavailableView(
                    "未対応の通報はありません",
                    systemImage: "checkmark.shield"
                )
            } else {
                List(reports) { report in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(report.targetType.label)
                            .font(.caption.bold())
                            .foregroundStyle(.indigo)
                        Text(report.reason)
                            .font(.body)
                        Text(report.createdAt, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack {
                            Button("対応済み") {
                                Task { await resolve(report) }
                            }
                            .buttonStyle(.bordered)

                            if let threadId = report.targetThreadId {
                                Button("投稿削除", role: .destructive) {
                                    Task { await deleteThread(threadId, report: report) }
                                }
                                .buttonStyle(.bordered)
                            }

                            if let replyId = report.targetReplyId {
                                Button("返信削除", role: .destructive) {
                                    Task { await deleteReply(replyId, report: report) }
                                }
                                .buttonStyle(.bordered)
                            }

                            if let messageId = report.targetMessageId {
                                Button("メッセージ削除", role: .destructive) {
                                    Task { await deleteMessage(messageId, report: report) }
                                }
                                .buttonStyle(.bordered)
                            }

                            if let roomId = report.targetRoomId {
                                Button("部屋停止", role: .destructive) {
                                    Task { await suspendRoom(roomId) }
                                }
                                .buttonStyle(.bordered)
                            }

                            if let userId = report.targetUserId {
                                Button("ユーザー停止", role: .destructive) {
                                    Task { await suspendUser(userId) }
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .font(.caption)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("運営管理")
        .task { await load() }
        .refreshable { await load() }
        .overlay(alignment: .top) {
            if let errorMessage {
                ErrorBanner(message: errorMessage).padding()
            }
        }
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            reports = try await supabase.fetchPendingReports()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func resolve(_ report: Report) async {
        do {
            try await supabase.resolveReport(report.id, note: nil)
            reports.removeAll { $0.id == report.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func suspendRoom(_ roomId: UUID) async {
        do {
            try await supabase.suspendRoom(roomId)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func suspendUser(_ userId: UUID) async {
        do {
            try await supabase.suspendUser(userId)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteThread(_ threadId: UUID, report: Report) async {
        do {
            try await supabase.adminDeleteThread(threadId)
            try await supabase.resolveReport(report.id, note: "スレッド削除")
            reports.removeAll { $0.id == report.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteReply(_ replyId: UUID, report: Report) async {
        do {
            try await supabase.adminDeleteReply(replyId)
            try await supabase.resolveReport(report.id, note: "返信削除")
            reports.removeAll { $0.id == report.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteMessage(_ messageId: UUID, report: Report) async {
        do {
            try await supabase.adminDeleteMessage(messageId)
            try await supabase.resolveReport(report.id, note: "メッセージ削除")
            reports.removeAll { $0.id == report.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ErrorBanner: View {
    let message: String

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(message)
                .font(.footnote)
        }
        .foregroundStyle(.red)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
