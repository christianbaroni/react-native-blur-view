import React from 'react';
import { StyleSheet, View } from 'react-native';
import Animated, { useAnimatedStyle, useSharedValue, withTiming, runOnJS, interpolate, Extrapolation, withSpring } from 'react-native-reanimated';
import consts from './consts';

const Component = React.forwardRef<JumpingTitle, Props>(({ initialText }, ref) => {

  const sv = useSharedValue(0);
  const [text, setText] = React.useState(initialText);

  const animation = useAnimatedStyle(() => ({
    opacity: interpolate(sv.value, [-consts.screen.width / 2, 0, consts.screen.width / 2], [0, 1, 0], Extrapolation.CLAMP),
    transform: [{ translateX: sv.value }],
  }), []);

  React.useImperativeHandle(ref, () => ({
    setText: text => {
      sv.value = withTiming(-consts.screen.width / 2, { duration: 200 }, () => {
        runOnJS(setText)(text);
      });
    },
  }), []);

  React.useEffect(() => {
    sv.value = consts.screen.width * 2;
    sv.value = withSpring(0, { damping: 24, stiffness: 200 });
  }, [text]);

  return (
    <View style={styles.container}>
      <Animated.Text style={[styles.text, animation]}>
        {text}
      </Animated.Text>
    </View>
  );
});

const JumpingTitle = React.memo(Component);

type JumpingTitle = {
  setText: (text: string) => void;
}

type Props = {
  initialText: string;
}

export { JumpingTitle };

const styles = StyleSheet.create({
  container: {
    width: consts.screen.width,
    height: 60,
    marginTop: 80,
    paddingHorizontal: 18,
  },
  text: {
    fontSize: 40, fontWeight: '800',
    color: consts.color.text.dynamic,
  },
});
