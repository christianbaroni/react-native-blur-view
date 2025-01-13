import React from "react";
import { View, Image, Text, StyleSheet, TouchableOpacity } from "react-native";

import Slider from "@react-native-community/slider";
import { BlurView, BlurViewStyles, type BlurViewProps, type BlurStyle } from "react-native-blur-view";
import Animated, { useSharedValue, useAnimatedProps, useDerivedValue } from "react-native-reanimated";

import { AnimatedText } from "./AnimatedText";
import { JumpingTitle } from "./JumpingTitle";

import { img } from "../assets";
import consts from "./consts";

const AnimatedBlurView = Animated.createAnimatedComponent(BlurView);

export const DynamicExample = () => {
  const [blurStyle, setBlurStyle] = React.useState<BlurStyle>("regular");
  const jumpingTitleRef = React.useRef<JumpingTitle>(null);

  const blurIntensity = useSharedValue(0);
  const saturationIntensity = useSharedValue(0);

  const switchStyle = () => {
    const i = (BlurViewStyles.indexOf(blurStyle) + 1) % BlurViewStyles.length;
    setBlurStyle(BlurViewStyles[i]!);
    jumpingTitleRef.current?.setText(BlurViewStyles[i]!.charAt(0).toUpperCase() + BlurViewStyles[i]!.slice(1));
  };

  const animatedProps = useAnimatedProps<BlurViewProps>(
    () => ({
      saturationIntensity: saturationIntensity.value,
      blurIntensity: blurIntensity.value,
    }),
    []
  );

  const blurValueText = useDerivedValue(() => {
    return `Blur: ${blurIntensity.value.toFixed(2).padStart(5, "0")}`;
  }, []);

  const saturationValueText = useDerivedValue(() => {
    return `Saturation: ${saturationIntensity.value.toFixed(2)}`;
  }, []);

  return (
    <>
      <JumpingTitle ref={jumpingTitleRef} initialText={blurStyle.charAt(0).toUpperCase() + blurStyle.slice(1)} />
      <View style={styles.container}>
        <Image source={img} style={styles.image} />
        <AnimatedBlurView style={styles.blur} blurStyle={blurStyle} animatedProps={animatedProps} />
        <View style={styles.text}>
          <AnimatedText style={styles.boldText} text={blurValueText} />
          <AnimatedText style={styles.boldText} text={saturationValueText} />
        </View>
        <TouchableOpacity onPress={switchStyle} style={styles.nextButton}>
          <Text style={styles.boldText}>→</Text>
        </TouchableOpacity>
      </View>
      <Text style={styles.label}>Blur intensity</Text>
      <Slider
        style={styles.slider}
        minimumValue={0}
        maximumValue={20}
        minimumTrackTintColor={consts.color.accent as unknown as string}
        onValueChange={(value) => (blurIntensity.value = value)}
      />
      <Text style={styles.label}>Saturation intensity</Text>
      <Slider
        style={styles.slider}
        minimumValue={0}
        maximumValue={3}
        minimumTrackTintColor={consts.color.accent as unknown as string}
        onValueChange={(value) => (saturationIntensity.value = value)}
      />
    </>
  );
};

const styles = StyleSheet.create({
  container: {
    width: consts.screen.width - 40,
    height: consts.screen.width / 2,
    marginBottom: 24,
    marginHorizontal: 20,
    overflow: "hidden",
    borderRadius: 26,
    borderCurve: "continuous",
  },
  label: {
    marginHorizontal: 20,
    color: consts.color.text.dynamic,
    fontSize: 16,
    fontWeight: "600",
  },
  image: {
    width: "100%",
    height: "100%",
  },
  blur: {
    position: "absolute",
    width: "100%",
    height: "100%",
  },
  text: {
    width: 138,
    position: "absolute",
    bottom: 10,
    left: 10,
    paddingVertical: 8,
    paddingHorizontal: 14,
    borderRadius: 18,
    borderCurve: "continuous",
    backgroundColor: "#ffffff55",
  },
  slider: {
    height: 40,
    marginBottom: 20,
    marginHorizontal: 20,
  },
  nextButton: {
    position: "absolute",
    bottom: 10,
    right: 10,
    width: 40,
    height: 40,
    justifyContent: "center",
    alignItems: "center",
    borderRadius: 20,
    borderCurve: "continuous",
    backgroundColor: "#ffffff55",
  },
  boldText: {
    color: "#fff",
    fontWeight: "600",
  },
});
