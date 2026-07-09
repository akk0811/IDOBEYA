/**
 * IDOBEYA Design System — Radius
 *
 * 角丸は定義済みトークンのみ使用してください。
 */

export const radius = {
  /** 8px — チップ・小さなバッジ・入力欄の内側要素 */
  small: 8,

  /** 12px — 画像プレースホルダー・ポール選択肢 */
  medium: 12,

  /** 16px — カード・リストアイテム（IDOBEYA 標準） */
  large: 16,

  /** 20px — 大きなカード・モーダル上部 */
  xl: 20,

  /** 完全なピル型 — ボタン・タグ・フローティングバー */
  full: 9999,
} as const;

export type Radius = typeof radius;
export type RadiusToken = keyof Radius;
