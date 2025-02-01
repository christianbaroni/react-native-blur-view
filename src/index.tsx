import { Platform, UIManager, requireNativeComponent, type StyleProp, type ViewStyle } from "react-native";

const LINKING_ERROR =
  `The package 'react-native-blur-view' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: "" }) +
  "- You rebuilt the app after installing the package\n" +
  "- You are not using Expo Go\n";

const customStyles = ["plain", "variable"] as const;

const standardStyles = ["dark", "extraLight", "light", "prominent", "regular"] as const;

const systemMaterialStyles = [
  /* Appearance-based materials */
  "chromeMaterial",
  "material",
  "thickMaterial",
  "thinMaterial",
  "ultraThinMaterial",

  /* Light materials */
  "chromeMaterialLight",
  "materialLight",
  "thickMaterialLight",
  "thinMaterialLight",
  "ultraThinMaterialLight",

  /* Dark materials */
  "chromeMaterialDark",
  "materialDark",
  "thickMaterialDark",
  "thinMaterialDark",
  "ultraThinMaterialDark",
] as const;

export const BlurViewStyles = [...customStyles, ...standardStyles, ...systemMaterialStyles] as const;

export type BlurStyle = (typeof BlurViewStyles)[number];
export type GradientPoints = [from: { x: number; y: number }, to: { x: number; y: number }];

type CustomStyle = (typeof customStyles)[number];
type StandardStyle = (typeof standardStyles)[number];
type SystemMaterial = (typeof systemMaterialStyles)[number];

interface BaseBlurViewProps {
  style?: StyleProp<ViewStyle>;
}

export interface StandardBlurProps extends BaseBlurViewProps {
  blurIntensity?: number;
  blurStyle?: CustomStyle | StandardStyle;
  gradientPoints?: never;
  saturationIntensity?: number;
}

export interface SystemMaterialBlurProps extends BaseBlurViewProps {
  blurIntensity?: never;
  blurStyle: SystemMaterial;
  gradientPoints?: never;
  saturationIntensity?: never;
}

export interface VariableBlurProps extends BaseBlurViewProps {
  blurIntensity?: number;
  blurStyle?: "variable";
  feather?: number;
  gradientPoints?: GradientPoints;
  saturationIntensity?: number;
}

export type BlurViewProps = StandardBlurProps | SystemMaterialBlurProps | VariableBlurProps;

const ComponentName = "BlurView";

export const BlurView =
  Platform.OS === "ios"
    ? UIManager.getViewManagerConfig(ComponentName) != null
      ? requireNativeComponent<BlurViewProps>(ComponentName)
      : () => {
          throw new Error(LINKING_ERROR);
        }
    : (_: BlurViewProps) => null;
