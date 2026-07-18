import SwiftUI

enum LegalDocumentRoute: String, Identifiable {
  case terms
  case privacy

  var id: String { rawValue }

  var title: String {
    switch self {
    case .terms:
      return "利用規約"
    case .privacy:
      return "プライバシーポリシー"
    }
  }

  @ViewBuilder
  var destination: some View {
    switch self {
    case .terms:
      TermsOfServiceView()
    case .privacy:
      PrivacyPolicyView()
    }
  }
}

struct TermsOfServiceView: View {
  var body: some View {
    LegalDocumentView(
      title: "利用規約",
      updatedAt: "制定日: 2026年7月19日",
      lead: "この利用規約は、IDOBEYAを安心して使うためのルールです。IDOBEYAは目的ごとの部屋で会話するSNSのため、投稿内容、部屋の運営、安全対応について定めます。",
      sections: [
        LegalSection(
          title: "1. 適用",
          body: "本規約は、IDOBEYAのアプリ、関連機能、運営が提供するサポートに適用されます。利用者は、本規約とプライバシーポリシーに同意したうえでサービスを利用します。"
        ),
        LegalSection(
          title: "2. サービスの内容",
          body: "IDOBEYAは、目的や関心ごとに応じた部屋で会話できる部屋型SNSです。公開部屋ではスレッド形式、招待制部屋や非公開部屋ではチャット形式の会話を想定しています。"
        ),
        LegalSection(
          title: "3. アカウント",
          body: "利用者は、正確な情報を用いてアカウントを作成してください。アカウントの管理責任は利用者本人にあり、第三者への譲渡、貸与、共有はできません。"
        ),
        LegalSection(
          title: "4. 部屋と公開範囲",
          body: "公開部屋の内容は、他の利用者が閲覧できる場合があります。招待制部屋や非公開部屋の内容は、参加メンバーを中心に表示されますが、通報対応、安全管理、法令対応のために運営が確認する場合があります。"
        ),
        LegalSection(
          title: "5. 投稿内容の責任",
          body: "利用者が投稿、返信、チャット、プロフィール、部屋名、説明文などで送信した内容については、利用者本人が責任を負います。第三者の権利、プライバシー、名誉、信用を侵害しないよう注意してください。"
        ),
        LegalSection(
          title: "6. 投稿内容の利用",
          body: "利用者は、サービス提供、表示、保存、通報対応、バックアップ、改善に必要な範囲で、運営が投稿内容を取り扱うことを許諾します。この許諾は、サービス運営に必要な範囲に限られます。"
        ),
        LegalSection(
          title: "7. 禁止事項",
          body: "誹謗中傷、脅迫、差別的表現、嫌がらせ、なりすまし、スパム、違法行為、性的または暴力的に過度な内容、個人情報の無断投稿、外部誘導を目的とした迷惑行為、サービスの運営を妨げる行為を禁止します。"
        ),
        LegalSection(
          title: "8. 個人情報や秘密情報の投稿",
          body: "住所、電話番号、メールアドレス、勤務先、学校名、本人確認書類、認証情報、他人の写真など、本人または第三者を特定し得る情報を無断で投稿しないでください。"
        ),
        LegalSection(
          title: "9. 通報・ブロック・ミュート",
          body: "利用者は、不適切な投稿、ユーザー、部屋を通報できます。また、必要に応じて他の利用者や部屋をブロックまたはミュートできます。運営は通報内容を確認し、必要な対応を行います。"
        ),
        LegalSection(
          title: "10. 運営による対応",
          body: "運営は、規約違反、法令違反、安全上の懸念、通報対応の必要がある場合、投稿削除、部屋の制限、アカウント停止、利用制限、関係機関への相談などを行うことがあります。"
        ),
        LegalSection(
          title: "11. 退会と利用停止",
          body: "利用者は、アプリ内の案内に従って退会できます。退会後、アカウントは無効化されます。ただし、法令対応、安全管理、紛争対応、不正利用防止に必要な情報は一定期間保持される場合があります。"
        ),
        LegalSection(
          title: "12. 知的財産権",
          body: "IDOBEYAの名称、ロゴ、UI、プログラム、デザイン、運営が作成したコンテンツに関する権利は、運営または正当な権利者に帰属します。"
        ),
        LegalSection(
          title: "13. 免責",
          body: "運営は、サービスの安全性と継続性の確保に努めますが、通信環境、外部サービス、利用者間のやり取り、投稿内容の正確性に起因する損害について、法令で認められる範囲で責任を負いません。"
        ),
        LegalSection(
          title: "14. 規約の変更",
          body: "運営は、法令変更、サービス内容の変更、安全管理上の必要に応じて本規約を変更することがあります。重要な変更がある場合は、アプリ内など適切な方法でお知らせします。"
        ),
        LegalSection(
          title: "15. お問い合わせ",
          body: "本規約に関するお問い合わせは、アプリ内のお問い合わせ導線、または運営が別途案内する連絡先からご連絡ください。"
        ),
      ]
    )
  }
}

struct PrivacyPolicyView: View {
  var body: some View {
    LegalDocumentView(
      title: "プライバシーポリシー",
      updatedAt: "制定日: 2026年7月19日",
      lead: "このプライバシーポリシーは、IDOBEYAが取得する情報、利用目的、公開範囲、保存、削除、第三者サービスの利用について説明するものです。",
      sections: [
        LegalSection(
          title: "1. 取得する情報",
          body: "メールアドレス、表示名、部屋ごとの表示名、プロフィール、参加部屋、投稿、返信、チャット、通報内容、ブロック・ミュート設定、通知設定、アカウント状態、利用日時などを取得します。"
        ),
        LegalSection(
          title: "2. 自動的に取得される情報",
          body: "サービスの安全な運営、不正利用防止、障害調査のため、端末情報、アプリの利用状況、ログ、IPアドレスに関連する情報、エラー情報などを取得する場合があります。"
        ),
        LegalSection(
          title: "3. 利用目的",
          body: "取得した情報は、ログイン、本人確認、プロフィール表示、部屋の作成・参加、投稿やチャットの表示、通知、通報対応、ブロック・ミュート、安全管理、不正利用防止、サービス改善のために利用します。"
        ),
        LegalSection(
          title: "4. 投稿内容と公開範囲",
          body: "公開部屋の投稿は、その部屋を閲覧できる利用者に表示されます。招待制部屋や非公開部屋の投稿は、原則として参加メンバーに表示されます。ただし、通報対応や安全管理のため、運営が確認する場合があります。"
        ),
        LegalSection(
          title: "5. 匿名投稿と表示名",
          body: "匿名投稿や部屋ごとの表示名を利用できる場合でも、運営は安全管理、通報対応、法令対応のために必要な範囲でアカウント情報と投稿情報を確認することがあります。"
        ),
        LegalSection(
          title: "6. 認証・保存先",
          body: "IDOBEYAは、認証、データベース、リアルタイム通信などのためにSupabaseを利用します。登録情報、投稿、部屋情報などは、サービス提供に必要な範囲でSupabase上に保存されます。"
        ),
        LegalSection(
          title: "7. 第三者提供",
          body: "本人の同意がある場合、法令に基づく場合、生命・身体・財産の保護に必要な場合、安全な運営や委託に必要な場合を除き、個人情報を第三者に提供しません。"
        ),
        LegalSection(
          title: "8. 委託先と外部サービス",
          body: "運営は、認証、データ保管、通知、分析、問い合わせ対応などのため、外部サービスや委託先を利用する場合があります。その場合、必要な範囲で情報を取り扱わせ、適切な管理に努めます。"
        ),
        LegalSection(
          title: "9. データの保存期間",
          body: "情報は、利用目的の達成に必要な期間保存します。退会後も、法令対応、安全管理、通報・紛争対応、不正利用防止、バックアップ管理のため、一定期間保持される場合があります。"
        ),
        LegalSection(
          title: "10. 削除・訂正・利用停止",
          body: "利用者は、アプリ内機能または運営が案内する窓口を通じて、登録情報の確認、訂正、削除、退会、利用停止に関する相談を行うことができます。"
        ),
        LegalSection(
          title: "11. 安全管理",
          body: "運営は、取得した情報の漏えい、紛失、改ざん、不正アクセスを防ぐため、アクセス制御、権限管理、ログ確認、必要な安全管理措置に努めます。"
        ),
        LegalSection(
          title: "12. 未成年の利用",
          body: "未成年の利用者は、保護者の同意を得たうえで利用してください。年齢に応じて、個人情報や投稿内容の取り扱いに特に注意してください。"
        ),
        LegalSection(
          title: "13. ポリシーの変更",
          body: "運営は、法令変更、サービス内容の変更、取り扱う情報の変更に応じて本ポリシーを変更することがあります。重要な変更がある場合は、アプリ内など適切な方法でお知らせします。"
        ),
        LegalSection(
          title: "14. お問い合わせ",
          body: "個人情報の取り扱いに関するお問い合わせは、アプリ内のお問い合わせ導線、または運営が別途案内する連絡先からご連絡ください。"
        ),
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
      VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
        VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
          Text(updatedAt)
            .font(AppTheme.typography.presets.caption.font())
            .foregroundStyle(AppTheme.colors.textSecondary)

          Text(lead)
            .font(AppTheme.typography.presets.body.font())
            .foregroundStyle(AppTheme.colors.textPrimary)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
        }

        ForEach(sections) { section in
          BaseCard {
            VStack(alignment: .leading, spacing: AppTheme.spacing.xs) {
              Text(section.title)
                .font(AppTheme.typography.presets.subHeading.font())
                .foregroundStyle(AppTheme.colors.textPrimary)
              Text(section.body)
                .font(AppTheme.typography.presets.body.font())
                .foregroundStyle(AppTheme.colors.textSecondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
      }
      .padding(.horizontal, AppTheme.spacing.lg)
      .padding(.top, AppTheme.spacing.sm)
      .padding(.bottom, AppTheme.spacing.xxl)
    }
    .background(AppTheme.colors.background)
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
  }
}

private struct LegalSection: Identifiable {
  let id = UUID()
  let title: String
  let body: String
}

#Preview("Terms") {
  NavigationStack {
    TermsOfServiceView()
  }
}

#Preview("Privacy") {
  NavigationStack {
    PrivacyPolicyView()
  }
}
