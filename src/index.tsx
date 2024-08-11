import { requireNativeComponent, UIManager, Platform, type ViewStyle, type StyleProp } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-blur-view' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: '- You have run \'pod install\'\n', default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

export const BlurViewStyles = [
  'variable', // default
  'plain',
  'regular',
  'light',
  'extraLight',
  'dark',
] as const;

export type BlurViewProps = {
  blurStyle?: typeof BlurViewStyles[number];
  blurIntensity?: number;
  saturationIntensity?: number;
  gradientPoints?: [
    from: { x: number; y: number },
    to: { x: number; y: number }
  ];
  style?: StyleProp<ViewStyle>;
};

const ComponentName = 'BlurView';

export const BlurView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<BlurViewProps>(ComponentName)
    : () => {
      throw new Error(LINKING_ERROR);
    };
