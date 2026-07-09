# IDOBEYA（イドベヤ）

**井戸端会議を、スマホの中の部屋へ。**

目的で集まり、安心して話せる部屋型SNSの iOS MVP です。

## ブランド

| 項目 | 内容 |
|---|---|
| アプリ名 | **IDOBEYA** |
| 読み方 | イドベヤ |
| 由来 | 井戸端会議 × 場 × 部屋型SNS |
| コンセプト | 井戸端会議を、スマホの中の部屋へ。 |
| 説明文 | 目的で集まり、安心して話せる部屋型SNS |

## 技術スタック

| 層 | 技術 |
|---|---|
| フロントエンド | Swift / SwiftUI (iOS 17+) |
| バックエンド | Supabase (Auth, PostgreSQL, Realtime) |
| 認証 | メールアドレス + パスワード |

## 部屋の種類

| 種類 | 会話形式 | 説明 |
|---|---|---|
| 公開部屋 | スレッド | 誰でも参加・閲覧可能 |
| 招待制部屋 | チャット | 招待コードで参加 |
| 非公開部屋 | チャット | 自分だけまたは極めて限定 |

## セットアップ手順

### 1. Supabase プロジェクト作成

1. [supabase.com](https://supabase.com) でプロジェクトを作成
2. SQL Editor で `supabase/migrations/001_initial_schema.sql` を実行
3. 続けて `supabase/migrations/002_admin_and_moderation.sql` を実行
4. Authentication → Providers で Email を有効化

### 2. iOS アプリの設定

1. 次のファイルをコピーして接続情報を入れる：

```bash
cd IDOBEYA
cp IDOBEYA/Resources/SupabaseSecrets.plist.example IDOBEYA/Resources/SupabaseSecrets.plist
```

2. `IDOBEYA/Resources/SupabaseSecrets.plist` を開き、Supabase の **Project URL** と **anon public** キーを貼り付ける

3. Xcode でプロジェクトを開く：

```bash
xcodegen generate
open IDOBEYA.xcodeproj
```

### 3. 運営管理者の設定

Supabase SQL Editor で管理者フラグを付与:

```sql
UPDATE profiles SET is_admin = true WHERE email = 'your-admin@email.com';
```

### 4. ビルド・実行

Xcode で iPhone シミュレータまたは実機を選択し、Run (⌘R)。

## プロジェクト構成

```
SNS app/
├── IDOBEYA/                    # iOS アプリ
│   ├── IDOBEYA/
│   │   ├── Models/             # データモデル
│   │   ├── Services/           # Supabase API
│   │   ├── Views/              # SwiftUI 画面
│   │   └── Config/             # アプリ設定・ブランド定数
│   ├── IDOBEYA.xcodeproj       # Xcode プロジェクト
│   └── project.yml             # XcodeGen 設定
├── supabase/
│   └── migrations/             # DB スキーマ
└── README.md
```

## MVP 機能一覧

### 実装済み

- [x] アカウント登録・ログイン
- [x] 公開部屋一覧・作成・参加
- [x] 公開部屋のスレッド投稿・返信
- [x] 招待制部屋の作成・チャット
- [x] 非公開部屋の作成・チャット
- [x] 部屋ごとの表示名変更
- [x] 通報機能（投稿・ユーザー・部屋）
- [x] ブロック機能
- [x] 運営管理画面（通報対応・部屋停止・ユーザー停止）
- [x] ミュート機能
- [x] 退会（アカウント無効化）
- [x] 部屋情報の編集
- [x] チャット・返信の削除
- [x] 運営による投稿削除

### 今後の拡張（MVP 後）

- プッシュ通知（APNs + Supabase Edge Functions）
- 画像投稿
- Apple ID / Google ログイン
- NG ワード自動検知
- おすすめ部屋 AI
- iPad 対応
- Android / Web 版

## 法務ドキュメント

App Store 公開前に以下を用意してください:

- 利用規約
- プライバシーポリシー
- コミュニティガイドライン

## ライセンス

Private - All rights reserved
