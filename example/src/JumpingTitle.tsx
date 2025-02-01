import React from "react";
import { StyleSheet, View } from "react-native";
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withTiming,
  runOnJS,
  interpolate,
  Extrapolation,
  withSpring,
  Easing,
  withSequence,
} from "react-native-reanimated";
import consts from "./consts";

const Component = React.forwardRef<JumpingTitle, Props>(({ initialText }, ref) => {
  const sv = useSharedValue(0);
  const [text, setText] = React.useState(initialText);

  const animation = useAnimatedStyle(
    () => ({
      opacity: interpolate(sv.value, [-40, 0, 40], [0, 1, 0], Extrapolation.CLAMP),
      transform: [{ translateX: sv.value }],
    }),
    []
  );

  React.useImperativeHandle(
    ref,
    () => ({
      setText: (text, direction = "next") => {
        sv.value = withSequence(
          withTiming(direction === "next" ? -40 : 40, { duration: 200, easing: Easing.bezier(0.22, 1, 0.36, 1) }, () => {
            runOnJS(setText)(text);
          }),
          withTiming(direction === "next" ? 40 : -40, { duration: 0, easing: Easing.linear }),
          withSpring(0, { damping: 30, mass: 0.9, stiffness: 500 })
        );
      },
    }),
    []
  );

  return (
    <View style={styles.container}>
      <Animated.Text style={[styles.text, animation]}>{text}</Animated.Text>
    </View>
  );
});

const JumpingTitle = React.memo(Component);

type JumpingTitle = {
  setText: (text: string, direction?: "next" | "prev") => void;
};

type Props = {
  initialText: string;
};

export { JumpingTitle };

const styles = StyleSheet.create({
  container: {
    width: consts.screen.width,
    height: 60,
    marginTop: 80,
    paddingHorizontal: 18,
  },
  text: {
    fontSize: 40,
    fontWeight: "800",
    color: consts.color.text.dynamic,
  },
});
