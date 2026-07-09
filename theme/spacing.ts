/**
 * IDOBEYA Design System — Spacing
 *
 * 許可された余白スケールのみ使用可能です。
 * padding: 17 などの自由な値は禁止。必ず theme.spacing.* を使用してください。
 */

/** 許可された余白値の一覧（型レベルで制約） */
export const SPACING_SCALE = [4, 8, 12, 16, 20, 24, 32, 40, 48, 64] as const;

export type SpacingValue = (typeof SPACING_SCALE)[number];

/**
 * セマンティックな余白トークン
 * md = 16px が基本単位
 */
export const spacing = {
  /** 4px — アイコンとテキストの最小間隔 */
  xxs: 4,

  /** 8px — コンパクトな要素間 */
  xs: 8,

  /** 12px — チップ内・小さなグループ */
  sm: 12,

  /** 16px — カード内パディング・標準間隔 */
  md: 16,

  /** 20px — セクション内・画面横パディング */
  lg: 20,

  /** 24px — セクション間 */
  xl: 24,

  /** 32px — 大きなセクション区切り */
  xxl: 32,

  /** 40px — 空状態・ヒーロー余白 */
  xxxl: 40,

  /** 48px — 画面上下の余白 */
  huge: 48,

  /** 64px — 特大スペーサー */
  massive: 64,
} as const satisfies Record<string, SpacingValue>;

export type Spacing = typeof spacing;
export type SpacingToken = keyof Spacing;
