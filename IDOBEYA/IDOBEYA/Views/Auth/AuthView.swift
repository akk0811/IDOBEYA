import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var supabase: SupabaseService

    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var agreedToTerms = false
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    header

                    if !AppConfig.isConfigured {
                        configWarning
                    }

                    VStack(spacing: 16) {
                        if isSignUp {
                            TextField("表示名", text: $displayName)
                                .textFieldStyle(RoomTextFieldStyle())
                        }

                        TextField("メールアドレス", text: $email)
                            .textFieldStyle(RoomTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        SecureField("パスワード（6文字以上）", text: $password)
                            .textFieldStyle(RoomTextFieldStyle())
                            .textContentType(isSignUp ? .newPassword : .password)
                    }

                    if isSignUp {
                        legalAgreement
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button(action: submit) {
                        Group {
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text(isSignUp ? "アカウント作成" : "ログイン")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                    .disabled(isLoading || !canSubmit)

                    Button(isSignUp ? "すでにアカウントをお持ちの方" : "新規登録はこちら") {
                        withAnimation { isSignUp.toggle() }
                        errorMessage = nil
                    }
                    .font(.footnote)
                    .foregroundStyle(.indigo)

                    legalLinks
                }
                .padding(24)
            }
            .background(Color(.systemGroupedBackground))
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "drop.fill")
                .font(.system(size: 52))
                .foregroundStyle(.indigo)
            Text(Brand.name)
                .font(.largeTitle.bold())
            Text(Brand.reading)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(Brand.concept)
                .font(.subheadline.weight(.medium))
                .multilineTextAlignment(.center)
            Text(Brand.tagline)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 32)
    }

    private var configWarning: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            Text("Supabase の接続設定が必要です。Resources/SupabaseSecrets.plist を設定してください。")
                .font(.footnote)
        }
        .padding()
        .background(Color.orange.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var legalLinks: some View {
        VStack(spacing: 10) {
            Text("ご利用前にご確認ください")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                legalLink(title: "利用規約", systemImage: "doc.text", destination: TermsOfServiceView())
                legalLink(title: "プライバシーポリシー", systemImage: "lock.shield", destination: PrivacyPolicyView())
            }
        }
    }

    private var legalAgreement: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                legalLink(title: "利用規約", systemImage: "doc.text", destination: TermsOfServiceView())
                legalLink(title: "プライバシーポリシー", systemImage: "lock.shield", destination: PrivacyPolicyView())
            }

            Toggle(isOn: $agreedToTerms) {
                Text("内容を確認し、同意します")
                    .font(.footnote.weight(.medium))
            }
            .tint(.indigo)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func legalLink<Destination: View>(
        title: String,
        systemImage: String,
        destination: Destination
    ) -> some View {
        NavigationLink {
            destination
        } label: {
            Label(title, systemImage: systemImage)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .foregroundStyle(.indigo)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.indigo.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private var canSubmit: Bool {
        guard AppConfig.isConfigured else { return false }
        guard !email.isEmpty, password.count >= 6 else { return false }
        if isSignUp {
            return !displayName.isEmpty && agreedToTerms
        }
        return true
    }

    private func submit() {
        errorMessage = nil
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                if isSignUp {
                    try await supabase.signUp(email: email, password: password, displayName: displayName)
                } else {
                    try await supabase.signIn(email: email, password: password)
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct RoomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        LegalDocumentView(
            title: "利用規約",
            updatedAt: "制定日: 2026年7月8日",
            lead: "この利用規約は、IDOBEYAを安心して使っていただくための基本的なルールです。",
            sections: [
                LegalSection(
                    title: "1. サービスについて",
                    body: "IDOBEYAは、目的や関心ごとに応じた部屋で会話できる部屋型SNSです。公開部屋ではスレッド形式、招待制部屋や非公開部屋ではチャット形式で利用できます。"
                ),
                LegalSection(
                    title: "2. アカウント登録",
                    body: "利用者は、正確な情報を用いてアカウントを作成してください。アカウントの管理は利用者本人の責任で行い、第三者への貸与や譲渡はできません。"
                ),
                LegalSection(
                    title: "3. 投稿と表示名",
                    body: "利用者は、部屋ごとに表示名を設定できます。投稿、返信、チャットメッセージなど、利用者が送信した内容については、本人が責任を負います。"
                ),
                LegalSection(
                    title: "4. 禁止事項",
                    body: "誹謗中傷、脅迫、差別的表現、なりすまし、スパム、違法行為、個人情報の無断投稿、過度に不快な内容、サービスの運営を妨げる行為を禁止します。"
                ),
                LegalSection(
                    title: "5. 通報・ブロック・ミュート",
                    body: "利用者は、不適切な投稿、ユーザー、部屋を通報できます。また、必要に応じて他の利用者をブロックまたはミュートできます。"
                ),
                LegalSection(
                    title: "6. 運営による対応",
                    body: "運営は、通報内容や利用状況を確認し、必要に応じて投稿の削除、部屋の停止、アカウントの停止などの対応を行うことがあります。"
                ),
                LegalSection(
                    title: "7. 退会",
                    body: "利用者は、マイページから退会できます。退会後、アカウントは無効化され、サービスを利用できなくなります。"
                ),
                LegalSection(
                    title: "8. 免責",
                    body: "運営は、サービスの安全性や継続性の確保に努めますが、通信環境、外部サービス、利用者間のやり取りに起因する損害について、法令で認められる範囲で責任を負いません。"
                ),
                LegalSection(
                    title: "9. 規約の変更",
                    body: "運営は、必要に応じて本規約を変更することがあります。重要な変更がある場合は、アプリ内など適切な方法でお知らせします。"
                ),
                LegalSection(
                    title: "10. お問い合わせ",
                    body: "本規約に関するお問い合わせは、アプリ内または運営が案内する窓口からご連絡ください。"
                )
            ]
        )
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        LegalDocumentView(
            title: "プライバシーポリシー",
            updatedAt: "制定日: 2026年7月8日",
            lead: "このプライバシーポリシーは、IDOBEYAで取り扱う情報と、その利用目的を説明するものです。",
            sections: [
                LegalSection(
                    title: "1. 取得する情報",
                    body: "メールアドレス、表示名、部屋ごとの表示名、参加している部屋、投稿、返信、チャットメッセージ、通報内容、ブロック・ミュートの設定、アカウント状態などを取得します。"
                ),
                LegalSection(
                    title: "2. 利用目的",
                    body: "取得した情報は、ログイン、プロフィール表示、部屋の作成・参加、投稿やチャットの表示、通報対応、安全な運営、不正利用の防止、サービス改善のために利用します。"
                ),
                LegalSection(
                    title: "3. 認証とデータ保管",
                    body: "IDOBEYAは、認証、データベース、リアルタイム通信のためにSupabaseを利用します。登録情報や投稿内容は、サービス提供に必要な範囲でSupabase上に保存されます。"
                ),
                LegalSection(
                    title: "4. 公開範囲",
                    body: "公開部屋の内容は、その部屋に参加または閲覧できる利用者に表示されます。招待制部屋や非公開部屋の内容は、原則として参加メンバーに表示されます。"
                ),
                LegalSection(
                    title: "5. 通報時の取り扱い",
                    body: "通報が行われた場合、運営は対象の投稿、部屋、ユーザー、通報理由などを確認し、必要な対応を行います。"
                ),
                LegalSection(
                    title: "6. 第三者提供",
                    body: "法令に基づく場合、本人の同意がある場合、または安全な運営に必要な範囲を除き、個人情報を第三者へ提供しません。"
                ),
                LegalSection(
                    title: "7. 退会とデータ",
                    body: "退会するとアカウントは無効化されます。投稿や通報履歴など、運営上または安全管理上必要な情報は、一定期間保持される場合があります。"
                ),
                LegalSection(
                    title: "8. 安全管理",
                    body: "運営は、取得した情報の漏えい、紛失、不正アクセスを防ぐため、適切な安全管理に努めます。"
                ),
                LegalSection(
                    title: "9. ポリシーの変更",
                    body: "運営は、必要に応じて本ポリシーを変更することがあります。重要な変更がある場合は、アプリ内など適切な方法でお知らせします。"
                ),
                LegalSection(
                    title: "10. お問い合わせ",
                    body: "個人情報の取り扱いに関するお問い合わせは、アプリ内または運営が案内する窓口からご連絡ください。"
                )
            ]
        )
    }
}

private struct LegalDocumentView: View {
    let title: String
    let updatedAt: String
    let lead: String
    let sections: [LegalSection]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(updatedAt)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(lead)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineSpacing(4)
                }
                .padding(.bottom, 4)

                ForEach(sections) { section in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(section.title)
                            .font(.headline)
                        Text(section.body)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct LegalSection: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}
