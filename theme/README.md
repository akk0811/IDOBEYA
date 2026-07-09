# IDOBEYA Design System v1.0

部屋型SNS「IDOBEYA」のアプリ全体で使用するデザイントークン定義です。  
100画面以上に拡張してもデザインの統一性を維持できるよう、**色・タイポグラフィ・余白・角丸・影・アニメーション**を TypeScript で一元管理します。

> **STEP1 の範囲**: 本フォルダ（`theme/`）のみ。画面・コンポーネントはまだ作成しません。

---

## フォルダ構成

```
theme/
├── colors.ts        # カラートークン
├── typography.ts    # フォントサイズ・太さ・行間
├── spacing.ts       # 余白スケール（許可値のみ）
├── radius.ts        # 角丸
├── shadow.ts        # 影（カード・モーダル・BottomSheet）
├── animation.ts     # アニメーション duration / easing
├── index.ts         # エクスポート集約（theme オブジェクト）
├── package.json     # パッケージ定義
├── tsconfig.json    # TypeScript 設定
├── eslint.config.mjs
└── README.md        # 本ドキュメント
```

---

## 各ファイルの役割

| ファイル | 役割 |
|---------|------|
| `colors.ts` | Primary / Accent / Background / Surface / Text / Semantic（Success, Warning, Error, Info）などセマンティックカラーを定義。内部パレットは `palette` に閉じ込め、画面から hex を直接使わない構造 |
| `typography.ts` | Display〜Tiny のフォントサイズ、Regular〜Bold のウェイト、各サイズに対応する line-height、よく使う `presets` 組み合わせ |
| `spacing.ts` | **4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 64** のみ許可。`theme.spacing.md` のようにセマンティック名で参照 |
| `radius.ts` | Small / Medium / Large / XL / Full の角丸トークン |
| `shadow.ts` | Small / Medium / Large の影。CSS 文字列 + React Native 向け構造化プロパティ |
| `animation.ts` | Fast / Normal / Slow の duration と ease 系イージング、推奨プリセット |
| `index.ts` | 全トークンを `theme` オブジェクトにまとめてエクスポート |

---

## 利用例

### 基本インポート

```typescript
import { theme } from '@idobeya/theme';
// または
import theme from './theme';
```

### カラー

```typescript
// ✅ 正しい使い方
const cardStyle = {
  backgroundColor: theme.colors.surface,
  borderColor: theme.colors.border,
  color: theme.colors.textPrimary,
};

// ❌ 禁止 — hex のベタ書き
const bad = { color: '#5F8D6B' };
```

### 余白

```typescript
// ✅ 正しい使い方
const containerStyle = {
  padding: theme.spacing.lg,       // 20px
  gap: theme.spacing.md,           // 16px
  marginBottom: theme.spacing.xl,  // 24px
};

// ❌ 禁止 — スケール外の値
const bad = { padding: 17 };
```

### タイポグラフィ

```typescript
const titleStyle = {
  fontSize: theme.typography.sizes.title,
  fontWeight: theme.typography.weights.bold,
  lineHeight: theme.typography.lineHeights.title,
};

// プリセット利用
const bodyPreset = theme.typography.presets.body;
```

### 角丸・影

```typescript
const cardStyle = {
  borderRadius: theme.radius.large,
  boxShadow: theme.shadow.small.css,
};
```

### アニメーション

```typescript
const transition = {
  transitionDuration: `${theme.animation.duration.normal}ms`,
  transitionTimingFunction: theme.animation.ease.easeInOut,
};

// プリセット
const modalTransition = theme.animation.presets.modal;
```

### React Native 例

```typescript
import { theme } from '@idobeya/theme';

const styles = StyleSheet.create({
  card: {
    backgroundColor: theme.colors.surface,
    borderRadius: theme.radius.large,
    padding: theme.spacing.md,
    ...theme.shadow.small,
  },
});
```

---

## 開発コマンド

```bash
cd theme
npm install
npm run typecheck   # TypeScript 型チェック
npm run lint        # ESLint（エラー 0 を維持）
```

---

## 実装ルール（再掲）

1. **色・数値のベタ書き禁止** — 必ず `theme.*` 経由で参照
2. **余白は定義済みスケールのみ** — `padding: 17` などは不可
3. **拡張時** — 新トークンは該当ファイルに追加し、`index.ts` からエクスポート
4. **ダークモード** — v1.1 で `colorsDark` またはセマンティック層の拡張を予定

---

## カラーパレット早見表（Light）

| トークン | 値 | 用途 |
|---------|-----|------|
| `primary` | `#5F8D6B` | ブランド・ボタン |
| `primaryLight` | `#7CAD88` | ハイライト背景 |
| `primaryDark` | `#4D7358` | 押下状態 |
| `accent` | `#D97706` | いいね・注目 |
| `background` | `#FAF8F5` | 画面背景 |
| `surface` | `#FFFFFF` | カード面 |
| `border` | `#E8E1D8` | 境界線 |
| `textPrimary` | `#333333` | 本文 |
| `textSecondary` | `#777777` | 補足 |
| `success` | `#10B981` | 成功 |
| `warning` | `#EAB308` | 注意 |
| `error` | `#D9534F` | エラー |
| `info` | `#3B82F6` | 情報 |

---

## 今後のステップ（STEP2 以降）

- [ ] React Native / Web 用スタイルヘルパー（`createStyles(theme)`）
- [ ] ダークモードトークン
- [ ] Figma Tokens との同期
- [ ] iOS Swift `Theme.swift` との自動同期スクリプト
