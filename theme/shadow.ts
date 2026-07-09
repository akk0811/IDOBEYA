/**
 * IDOBEYA Design System — Shadow
 *
 * カード・モーダル・BottomSheet で再利用する影トークン。
 * Web (CSS) と React Native の両方で使える構造です。
 */

import { colors } from './colors';

/** 影の構造化トークン */
export interface ShadowDefinition {
  /** CSS box-shadow 用文字列 */
  readonly css: string;
  readonly offsetX: number;
  readonly offsetY: number;
  readonly blur: number;
  readonly spread: number;
  readonly color: string;
  /** React Native elevation (Android) */
  readonly elevation: number;
}

/** @internal 影色はテーマから派生。hex ベタ書きを避ける */
const shadowColor = `${colors.textPrimary}0A`;

const shadowColorMedium = `${colors.textPrimary}14`;

const shadowColorLarge = `${colors.textPrimary}1F`;

export const shadow = {
  /**
   * Small — リストカード・チップ
   * 使用例: 部屋カード、投稿カード
   */
  small: {
    css: `0 1px 4px 0 ${shadowColor}`,
    offsetX: 0,
    offsetY: 1,
    blur: 4,
    spread: 0,
    color: shadowColor,
    elevation: 2,
  },

  /**
   * Medium — モーダル・ドロップダウン
   * 使用例: 通報シート、部屋選択メニュー
   */
  medium: {
    css: `0 4px 12px 0 ${shadowColorMedium}`,
    offsetX: 0,
    offsetY: 4,
    blur: 12,
    spread: 0,
    color: shadowColorMedium,
    elevation: 6,
  },

  /**
   * Large — BottomSheet・フローティングパネル
   * 使用例: 投稿オプション、画像ビューア
   */
  large: {
    css: `0 8px 24px 0 ${shadowColorLarge}`,
    offsetX: 0,
    offsetY: 8,
    blur: 24,
    spread: 0,
    color: shadowColorLarge,
    elevation: 12,
  },
} as const satisfies Record<string, ShadowDefinition>;

export type Shadow = typeof shadow;
export type ShadowToken = keyof Shadow;
