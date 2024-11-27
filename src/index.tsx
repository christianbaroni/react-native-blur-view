import { requireNativeComponent, UIManager, Platform, type ViewStyle, type StyleProp } from "react-native";

const LINKING_ERROR =
  `The package 'react-native-blur-view' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: "" }) +
  "- You rebuilt the app after installing the package\n" +
  "- You are not using Expo Go\n";

export type BlurViewStyle = 'plain' | 'extraLight' | 'light' | 'dark' | 'regular' | 'prominent';
export type FadeStyle = 'top' | 'bottom' | 'left' | 'right';

export type BlurViewProps = {
  blurStyle?: BlurViewStyle;
  blurIntensity?: number;
  saturationIntensity?: number;
  fadePercent?: number;
  fadeStyle?: FadeStyle;
  style?: StyleProp<ViewStyle>;
};

const ComponentName = "BlurView";

export const BlurView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<BlurViewProps>(ComponentName)
    : () => {
      throw new Error(LINKING_ERROR);
    };
