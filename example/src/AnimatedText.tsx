import React from 'react';
import { TextInput, type TextStyle, type StyleProp } from 'react-native';
import Animated, { type SharedValue, useAnimatedProps } from 'react-native-reanimated';

Animated.addWhitelistedNativeProps({ text: true });
const AnimatedTextInput = Animated.createAnimatedComponent(TextInput);

export const AnimatedText: React.FC<Props> = ({ text, style }) => {
  const animatedProps = useAnimatedProps(() => ({
    text: text.value,
  } as any));

  return (
    <AnimatedTextInput
      style={style}
      underlineColorAndroid='transparent'
      editable={false}
      value={text.value}
      {...{ animatedProps }}
    />
  );
};

type Props = {
  text: SharedValue<string>;
  style?: StyleProp<TextStyle>;
};
