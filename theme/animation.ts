/**
 * IDOBEYA Design System — Animation
 *
 * アニメーションの duration と easing を一元管理します。
 * 画面側では theme.animation.duration.* / ease.* を使用してください。
 */

/** アニメーション時間（ミリ秒） */
export const duration = {
  /** 150ms — ボタン押下・チップ選択 */
  fast: 150,

  /** 250ms — 画面遷移・セクション展開（標準） */
  normal: 250,

  /** 400ms — モーダル表示・大きなレイアウト変化 */
  slow: 400,
} as const;

/** イージング関数（CSS transition-timing-function 互換） */
export const ease = {
  ease: 'ease',
  easeIn: 'ease-in',
  easeOut: 'ease-out',
  easeInOut: 'ease-in-out',
} as const;

/**
 * 推奨プリセット（duration + easing の組み合わせ）
 */
export const presets = {
  press: {
    duration: duration.fast,
    easing: ease.easeOut,
  },
  transition: {
    duration: duration.normal,
    easing: ease.easeInOut,
  },
  modal: {
    duration: duration.slow,
    easing: ease.easeOut,
  },
} as const;

export const animation = {
  duration,
  ease,
  presets,
} as const;

export type Animation = typeof animation;
export type DurationToken = keyof typeof duration;
export type EaseToken = keyof typeof ease;
