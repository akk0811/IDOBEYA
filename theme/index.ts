/**
 * IDOBEYA Design System v1.0
 *
 * アプリ全体のデザイントークンを一元エクスポートします。
 *
 * @example
 * import { theme } from './theme';
 *
 * const styles = {
 *   backgroundColor: theme.colors.background,
 *   padding: theme.spacing.md,
 *   borderRadius: theme.radius.large,
 * };
 */

export { colors } from './colors';
export type { Colors, ColorToken } from './colors';

export { typography, fontSizes, fontWeights, lineHeights } from './typography';
export type {
  Typography,
  FontSizeToken,
  FontWeightToken,
  LineHeightToken,
} from './typography';

export { spacing, SPACING_SCALE } from './spacing';
export type { Spacing, SpacingToken, SpacingValue } from './spacing';

export { radius } from './radius';
export type { Radius, RadiusToken } from './radius';

export { shadow } from './shadow';
export type { Shadow, ShadowToken, ShadowDefinition } from './shadow';

export { animation, duration, ease, presets as animationPresets } from './animation';
export type { Animation, DurationToken, EaseToken } from './animation';

import { colors } from './colors';
import { typography } from './typography';
import { spacing } from './spacing';
import { radius } from './radius';
import { shadow } from './shadow';
import { animation } from './animation';

/** デザインシステムのルートオブジェクト */
export const theme = {
  colors,
  typography,
  spacing,
  radius,
  shadow,
  animation,
} as const;

export type Theme = typeof theme;

export default theme;
