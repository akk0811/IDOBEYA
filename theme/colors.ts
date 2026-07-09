/**
 * IDOBEYA Design System — Colors
 *
 * 画面・コンポーネントでは hex を直接書かず、theme.colors.* を使用してください。
 * パレット（palette）は内部専用。外部からは semantic colors のみ参照します。
 */

/** @internal デザイントークンの元色。直接参照しないこと */
const palette = {
  green400: '#7CAD88',
  green500: '#5F8D6B',
  green600: '#4D7358',
  green700: '#3D5C46',
  amber500: '#D97706',
  amber400: '#F59E0B',
  cream50: '#FAF8F5',
  cream100: '#F5F1EB',
  white: '#FFFFFF',
  stone800: '#333333',
  stone500: '#777777',
  stone300: '#E8E1D8',
  stone200: '#F0EBE3',
  red500: '#D9534F',
  red400: '#E57373',
  blue500: '#3B82F6',
  blue400: '#60A5FA',
  emerald500: '#10B981',
  yellow500: '#EAB308',
} as const;

export const colors = {
  /** メインブランドカラー。ボタン・リンク・アクティブ状態に使用 */
  primary: palette.green500,

  /** Primary の明るいバリエーション。ホバー・背景ハイライトに使用 */
  primaryLight: palette.green400,

  /** Primary の暗いバリエーション。押下状態・強調テキストに使用 */
  primaryDark: palette.green600,

  /** アクセントカラー。いいね・通知バッジ・注目要素に使用 */
  accent: palette.amber500,

  /** アプリ全体の背景。温かみのあるオフホワイト */
  background: palette.cream50,

  /** カード・入力欄・モーダルなどの表面色 */
  surface: palette.white,

  /** 区切り線・カード枠・非アクティブ境界に使用 */
  border: palette.stone300,

  /** 本文・見出しなど主要テキスト */
  textPrimary: palette.stone800,

  /** 補足説明・プレースホルダー・メタ情報 */
  textSecondary: palette.stone500,

  /** 成功状態（参加完了・保存成功など） */
  success: palette.emerald500,

  /** 注意喚起（未保存の変更など） */
  warning: palette.yellow500,

  /** エラー・削除・危険な操作 */
  error: palette.red500,

  /** 情報・ヒント・運営からのお知らせ */
  info: palette.blue500,
} as const;

export type Colors = typeof colors;
export type ColorToken = keyof Colors;
