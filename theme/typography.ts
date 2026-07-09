/**
 * IDOBEYA Design System — Typography
 *
 * フォントサイズ・太さ・行間はここで一元管理します。
 * 画面側では theme.typography.sizes.* / weights.* / lineHeights.* を使用してください。
 */

/** フォントサイズ（px） */
export const fontSizes = {
  /** ブランド・ヒーロー見出し（28px） */
  display: 28,

  /** 画面タイトル・大見出し（20px） */
  title: 20,

  /** セクション見出し（17px） */
  heading: 17,

  /** サブ見出し・カードタイトル（15px） */
  subHeading: 15,

  /** 本文・ボタンラベル（14px） */
  body: 14,

  /** 補足・メタ情報（12px） */
  caption: 12,

  /** バッジ・極小ラベル（10px） */
  tiny: 10,
} as const;

/** フォントウェイト */
export const fontWeights = {
  regular: '400',
  medium: '500',
  semibold: '600',
  bold: '700',
} as const;

/**
 * 行間（line-height）
 * 各サイズに対応する倍率。CSS では `lineHeight: theme.typography.lineHeights.body` のように使用
 */
export const lineHeights = {
  display: 36,
  title: 28,
  heading: 24,
  subHeading: 22,
  body: 20,
  caption: 16,
  tiny: 14,
} as const;

export const typography = {
  sizes: fontSizes,
  weights: fontWeights,
  lineHeights,
  /**
   * よく使う組み合わせのプリセット
   * 例: theme.typography.presets.body
   */
  presets: {
    display: {
      fontSize: fontSizes.display,
      fontWeight: fontWeights.bold,
      lineHeight: lineHeights.display,
    },
    title: {
      fontSize: fontSizes.title,
      fontWeight: fontWeights.bold,
      lineHeight: lineHeights.title,
    },
    heading: {
      fontSize: fontSizes.heading,
      fontWeight: fontWeights.semibold,
      lineHeight: lineHeights.heading,
    },
    subHeading: {
      fontSize: fontSizes.subHeading,
      fontWeight: fontWeights.semibold,
      lineHeight: lineHeights.subHeading,
    },
    body: {
      fontSize: fontSizes.body,
      fontWeight: fontWeights.regular,
      lineHeight: lineHeights.body,
    },
    caption: {
      fontSize: fontSizes.caption,
      fontWeight: fontWeights.regular,
      lineHeight: lineHeights.caption,
    },
    tiny: {
      fontSize: fontSizes.tiny,
      fontWeight: fontWeights.medium,
      lineHeight: lineHeights.tiny,
    },
  },
} as const;

export type Typography = typeof typography;
export type FontSizeToken = keyof typeof fontSizes;
export type FontWeightToken = keyof typeof fontWeights;
export type LineHeightToken = keyof typeof lineHeights;
