import SliderComponent from "@react-native-community/slider";
import React from "react";
import { View, Image, Text, StyleSheet, TouchableOpacity, Platform } from "react-native";
import { BlurView, BlurViewStyles, type BlurViewProps, type BlurStyle, type VariableBlurProps } from "react-native-blur-view";
import Animated, {
  useSharedValue,
  useAnimatedProps,
  useDerivedValue,
  type SharedValue,
  useAnimatedStyle,
  type AnimatedStyle,
} from "react-native-reanimated";
import { img } from "../assets";
import { AnimatedText } from "./AnimatedText";
import { JumpingTitle } from "./JumpingTitle";
import consts from "./consts";

export type VariableBlurSettings = Required<Pick<VariableBlurProps, "blurIntensity" | "feather">> & { height: number };

export const AnimatedBlurView = Animated.createAnimatedComponent<BlurViewProps>(BlurView);

const Slider = React.memo(SliderComponent);

export const START_VALUES = {
  blurIntensity: 10,
  saturationIntensity: 0,
  gradientYStart: 0,
  gradientYEnd: 1,
  feather: 8,
  variableBlur: {
    blurIntensity: 3,
    feather: 10,
    height: 70,
  },
};

const Controls = React.memo(function Controls({
  containerStyle,
  onValueChange,
  updateVariableBlur,
  variableBlurSettings,
  variableBlurStyle,
}: {
  containerStyle: AnimatedStyle;
  onValueChange: {
    blur: (value: number) => void;
    saturation: (value: number) => void;
    gradientYStart: (value: number) => void;
    gradientYEnd: (value: number) => void;
    feather: (value: number) => void;
  };
  updateVariableBlur: (prop: keyof VariableBlurSettings, value: number) => void;
  variableBlurSettings: SharedValue<VariableBlurSettings>;
  variableBlurStyle: AnimatedStyle;
}) {
  const heightText = useDerivedValue(() => trimTrailingZeros(variableBlurSettings.value.height, 1));
  const blurIntensityText = useDerivedValue(() => trimTrailingZeros(variableBlurSettings.value.blurIntensity, 1));
  const featherText = useDerivedValue(() => trimTrailingZeros(variableBlurSettings.value.feather, 1));

  return (
    <>
      <Animated.View style={containerStyle}>
        <Text style={styles.label}>Blur intensity</Text>
        <Slider
          lowerLimit={0}
          maximumValue={50}
          minimumTrackTintColor={consts.color.accent as unknown as string}
          minimumValue={0}
          onValueChange={onValueChange.blur}
          style={styles.slider}
          upperLimit={50}
          value={START_VALUES.blurIntensity}
        />
        <Text style={styles.label}>Saturation intensity</Text>
        <Slider
          lowerLimit={0}
          maximumValue={3}
          minimumTrackTintColor={consts.color.accent as unknown as string}
          minimumValue={0}
          onValueChange={onValueChange.saturation}
          style={styles.slider}
          upperLimit={3}
          value={START_VALUES.saturationIntensity}
        />

        <Animated.View style={variableBlurStyle}>
          <Text style={styles.label}>Gradient start point</Text>
          <Slider
            lowerLimit={0}
            maximumValue={1}
            minimumTrackTintColor={consts.color.accent as unknown as string}
            minimumValue={0}
            onValueChange={onValueChange.gradientYStart}
            style={styles.slider}
            upperLimit={1}
            value={START_VALUES.gradientYStart}
          />
          <Text style={styles.label}>Gradient end point</Text>
          <Slider
            lowerLimit={0}
            maximumValue={1}
            minimumTrackTintColor={consts.color.accent as unknown as string}
            minimumValue={0}
            onValueChange={onValueChange.gradientYEnd}
            style={styles.slider}
            upperLimit={1}
            value={START_VALUES.gradientYEnd}
          />
          <Text style={styles.label}>Feather</Text>
          <Slider
            lowerLimit={0}
            maximumValue={50}
            minimumTrackTintColor={consts.color.accent as unknown as string}
            minimumValue={0}
            onValueChange={onValueChange.feather}
            style={styles.slider}
            upperLimit={50}
            value={START_VALUES.feather}
          />
        </Animated.View>
      </Animated.View>

      <View style={styles.divider} />

      <View style={styles.labelContainer}>
        <Text style={styles.label}>Variable blur height</Text>
        <AnimatedText style={[styles.label, styles.labelRight]} text={heightText} />
      </View>
      <Slider
        lowerLimit={0}
        maximumValue={150}
        minimumTrackTintColor={consts.color.accent as unknown as string}
        minimumValue={0}
        onValueChange={(value) => updateVariableBlur("height", value)}
        style={styles.slider}
        upperLimit={150}
        value={START_VALUES.variableBlur.height}
      />

      <View style={styles.labelContainer}>
        <Text style={styles.label}>Variable blur intensity</Text>
        <AnimatedText style={[styles.label, styles.labelRight]} text={blurIntensityText} />
      </View>
      <Slider
        lowerLimit={0}
        maximumValue={50}
        minimumTrackTintColor={consts.color.accent as unknown as string}
        minimumValue={0}
        onValueChange={(value) => updateVariableBlur("blurIntensity", value)}
        style={styles.slider}
        upperLimit={50}
        value={START_VALUES.variableBlur.blurIntensity}
      />

      <View style={styles.labelContainer}>
        <Text style={styles.label}>Variable blur feather</Text>
        <AnimatedText style={[styles.label, styles.labelRight]} text={featherText} />
      </View>
      <Slider
        lowerLimit={0}
        maximumValue={50}
        minimumTrackTintColor={consts.color.accent as unknown as string}
        minimumValue={0}
        onValueChange={(value) => updateVariableBlur("feather", value)}
        style={styles.slider}
        upperLimit={50}
        value={START_VALUES.variableBlur.feather}
      />
    </>
  );
});

function trimTrailingZeros(num: number, precision = 2) {
  "worklet";
  const str = num.toFixed(precision);
  if (Number.isInteger(num)) return num.toString() + ".0";
  if (str === "0.00") return "0.0";
  return str;
}

const BlurPreview = React.memo(function BlurPreview({
  blurIntensity,
  feather,
  gradientYEnd,
  gradientYStart,
  isAdjustable,
  isVariableBlur,
  onSwitchStyle,
  saturationIntensity,
}: {
  blurIntensity: SharedValue<number>;
  feather: SharedValue<number>;
  gradientYEnd: SharedValue<number>;
  gradientYStart: SharedValue<number>;
  isAdjustable: boolean;
  isVariableBlur: boolean;
  onSwitchStyle: (direction: "next" | "prev") => void;
  saturationIntensity: SharedValue<number>;
}) {
  const blurValueText = useDerivedValue(() => `Blur: ${trimTrailingZeros(blurIntensity.value)}`);
  const saturationValueText = useDerivedValue(() => `Saturation: ${trimTrailingZeros(saturationIntensity.value)}`);

  const gradientStartText = useDerivedValue(() => `Blur start: ${trimTrailingZeros(gradientYStart.value)}`);
  const gradientEndText = useDerivedValue(() => `Blur end: ${trimTrailingZeros(gradientYEnd.value)}`);
  const featherText = useDerivedValue(() => `Feather: ${trimTrailingZeros(feather.value)}`);

  return (
    <>
      {isAdjustable && (
        <View style={styles.textContainer}>
          <BlurView blurStyle="light" style={styles.blurOverlay} />
          <Animated.View style={styles.text}>
            <AnimatedText style={styles.boldText} text={blurValueText} />
            <AnimatedText style={styles.boldText} text={saturationValueText} />
            {isVariableBlur && (
              <>
                <AnimatedText style={styles.boldText} text={gradientStartText} />
                <AnimatedText style={styles.boldText} text={gradientEndText} />
                <AnimatedText style={styles.boldText} text={featherText} />
              </>
            )}
          </Animated.View>
        </View>
      )}
      <View style={styles.arrowContainer}>
        <TouchableOpacity onPress={() => onSwitchStyle("prev")} style={styles.nextButton}>
          <BlurView blurStyle="light" style={styles.blurOverlay} />
          <Text style={styles.arrowText}>←</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => onSwitchStyle("next")} style={styles.nextButton}>
          <BlurView blurStyle="light" style={styles.blurOverlay} />
          <Text style={styles.arrowText}>→</Text>
        </TouchableOpacity>
      </View>
    </>
  );
});

export const DynamicExample = React.memo(function DynamicExample({
  updateVariableBlur,
  variableBlurSettings,
}: {
  updateVariableBlur: (prop: keyof VariableBlurSettings, value: number) => void;
  variableBlurSettings: SharedValue<VariableBlurSettings>;
}) {
  const [blurStyle, setBlurStyle] = React.useState<BlurStyle>("variable");
  const jumpingTitleRef = React.useRef<JumpingTitle>(null);

  const blurIntensity = useSharedValue(START_VALUES.blurIntensity);
  const saturationIntensity = useSharedValue(START_VALUES.saturationIntensity);
  const feather = useSharedValue(START_VALUES.feather);
  const gradientYStart = useSharedValue(START_VALUES.gradientYStart);
  const gradientYEnd = useSharedValue(START_VALUES.gradientYEnd);

  const switchStyle = React.useCallback((direction: "next" | "prev" = "next") => {
    setBlurStyle((currentStyle) => {
      let i = BlurViewStyles.indexOf(currentStyle) + (direction === "next" ? 1 : -1);
      if (i < 0) i = BlurViewStyles.length - 1;
      i = i % BlurViewStyles.length;
      const newStyle = BlurViewStyles[i]!;
      jumpingTitleRef.current?.setText(newStyle.charAt(0).toUpperCase() + newStyle.slice(1), direction);
      return newStyle;
    });
  }, []);

  const animatedProps = useAnimatedProps<BlurViewProps>(() => ({
    blurIntensity: blurIntensity.value,
    feather: feather.value,
    saturationIntensity: saturationIntensity.value,
    gradientPoints: [
      { x: 0.5, y: gradientYStart.value },
      { x: 0.5, y: gradientYEnd.value },
    ],
  }));

  const onValueChange = React.useMemo(
    () => ({
      blur: (value: number) => (blurIntensity.value = value),
      saturation: (value: number) => (saturationIntensity.value = value),
      gradientYStart: (value: number) => (gradientYStart.value = value),
      gradientYEnd: (value: number) => (gradientYEnd.value = value),
      feather: (value: number) => (feather.value = value),
    }),
    []
  );

  const { isAdjustable, isVariableBlur } = React.useMemo(() => {
    const isAdjustable = !blurStyle.toLowerCase().includes("material");
    return { isAdjustable, isVariableBlur: blurStyle === "variable" };
  }, [blurStyle]);

  const containerStyle = useAnimatedStyle(() => ({
    display: isAdjustable ? "flex" : "none",
  }));

  const variableBlurStyle = useAnimatedStyle(() => ({
    display: isVariableBlur ? "flex" : "none",
  }));

  const [initialText] = React.useState(blurStyle.charAt(0).toUpperCase() + blurStyle.slice(1));

  return (
    <>
      <JumpingTitle initialText={initialText} ref={jumpingTitleRef} />
      <View style={styles.container}>
        <Image source={img} style={styles.image} />
        <AnimatedBlurView animatedProps={animatedProps} blurStyle={blurStyle} style={styles.blur} />
        <View style={styles.blurBorder} />
        <BlurPreview
          blurIntensity={blurIntensity}
          feather={feather}
          gradientYEnd={gradientYEnd}
          gradientYStart={gradientYStart}
          isAdjustable={isAdjustable}
          isVariableBlur={isVariableBlur}
          onSwitchStyle={switchStyle}
          saturationIntensity={saturationIntensity}
        />
      </View>
      <Controls
        containerStyle={containerStyle}
        onValueChange={onValueChange}
        updateVariableBlur={updateVariableBlur}
        variableBlurSettings={variableBlurSettings}
        variableBlurStyle={variableBlurStyle}
      />
    </>
  );
});

const styles = StyleSheet.create({
  container: {
    width: consts.screen.width - 40,
    height: consts.screen.width / 2,
    marginBottom: 24,
    marginHorizontal: 20,
    overflow: "hidden",
    borderRadius: 28,
    borderCurve: "continuous",
  },
  divider: {
    backgroundColor: consts.borderColor,
    borderCurve: "continuous",
    borderRadius: 1,
    height: 1,
    marginBottom: 32,
    marginTop: 12,
    width: "100%",
  },
  label: {
    marginHorizontal: 20,
    color: consts.color.text.dynamic,
    fontSize: 16,
    fontWeight: "600",
  },
  labelContainer: {
    alignItems: "center",
    flexDirection: "row",
    justifyContent: "space-between",
  },
  labelRight: {
    minWidth: 100,
    textAlign: "right",
  },
  image: {
    width: "100%",
    height: "100%",
  },
  blur: {
    bottom: 0,
    height: "100%",
    left: 0,
    position: "absolute",
    right: 0,
    top: 0,
    width: "100%",
  },
  blurBorder: {
    borderColor: consts.borderColor,
    borderCurve: "continuous",
    borderRadius: 28,
    borderWidth: 4 / 3,
    bottom: 0,
    height: "100%",
    left: 0,
    overflow: "hidden",
    position: "absolute",
    right: 0,
    top: 0,
    width: "100%",
  },
  text: {
    paddingVertical: 8,
    paddingHorizontal: 14,
    width: 140,
  },
  textContainer: {
    backgroundColor: Platform.OS === "ios" ? "transparent" : "#ffffff55",
    borderCurve: "continuous",
    borderRadius: 18,
    overflow: "hidden",
    position: "absolute",
    bottom: 10,
    left: 10,
  },
  slider: {
    height: 40,
    marginBottom: 20,
    marginHorizontal: 20,
  },
  nextButton: {
    width: 36,
    height: 36,
    justifyContent: "center",
    alignItems: "center",
    borderRadius: 20,
    borderCurve: "continuous",
    backgroundColor: Platform.OS === "ios" ? "transparent" : "#ffffff55",
    overflow: "hidden",
  },
  blurOverlay: {
    height: "100%",
    position: "absolute",
    width: "100%",
  },
  arrowContainer: {
    bottom: 10,
    flexDirection: "row",
    gap: 8,
    position: "absolute",
    right: 10,
  },
  arrowText: {
    color: "#fff",
    fontSize: 18,
    fontWeight: "800",
    textAlign: "center",
  },
  boldText: {
    color: "#fff",
    fontWeight: "600",
  },
});
