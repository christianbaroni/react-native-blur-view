import { StyleSheet, Text, ScrollView } from "react-native";
import { AnimatedBlurView, DynamicExample, START_VALUES, type VariableBlurSettings } from "./DynamicExample";
import consts from "./consts";
import { runOnUI, useAnimatedProps, useAnimatedStyle, useSharedValue } from "react-native-reanimated";
import { useCallback } from "react";

export const App = () => {
  const variableBlurProps = useSharedValue<VariableBlurSettings>({
    blurIntensity: START_VALUES.variableBlur.blurIntensity,
    feather: START_VALUES.variableBlur.feather,
    height: START_VALUES.variableBlur.height,
  });

  const blurViewProps = useAnimatedProps(() => ({
    blurIntensity: variableBlurProps.value.blurIntensity,
    feather: variableBlurProps.value.feather,
  }));

  const heightStyle = useAnimatedStyle(() => ({ height: variableBlurProps.value.height, width: consts.screen.width }));

  const updateVariableBlur = useCallback((prop: keyof VariableBlurSettings, value: number) => {
    runOnUI(() => {
      const propToSet = prop;
      variableBlurProps.modify((props) => ({
        ...props,
        [propToSet]: value,
      }));
    })();
  }, []);

  return (
    <>
      <ScrollView showsVerticalScrollIndicator={false}>
        <DynamicExample updateVariableBlur={updateVariableBlur} variableBlurSettings={variableBlurProps} />
        <Text style={styles.text}>{text.repeat(10)}</Text>
      </ScrollView>

      <AnimatedBlurView
        animatedProps={blurViewProps}
        blurStyle="variable"
        gradientPoints={[
          { x: 0.5, y: 1 },
          { x: 0.5, y: 0 },
        ]}
        style={[styles.top, heightStyle]}
      />

      <AnimatedBlurView
        animatedProps={blurViewProps}
        blurStyle="variable"
        gradientPoints={[
          { x: 0.5, y: 0 },
          { x: 0.5, y: 1 },
        ]}
        style={[styles.bottom, heightStyle]}
      />
    </>
  );
};

const styles = StyleSheet.create({
  bottom: {
    left: 0,
    overflow: "visible",
    pointerEvents: "none",
    position: "absolute",
    right: 0,
    bottom: 0,
  },
  top: {
    left: 0,
    overflow: "visible",
    pointerEvents: "none",
    position: "absolute",
    right: 0,
    top: 0,
  },
  text: {
    marginHorizontal: 20,
    marginBottom: 40,
    color: consts.color.text.dynamic,
    fontSize: 18,
    lineHeight: 28,
  },
});

const text =
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
