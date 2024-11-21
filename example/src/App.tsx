import { StyleSheet, View, Text, ScrollView } from 'react-native';
import { BlurView } from 'react-native-blur-view';
import { DynamicExample } from './DynamicExample';
import consts from './consts';

export const App = () => (
  <>
    <ScrollView
      showsVerticalScrollIndicator={false}
    >
      <DynamicExample />
      <Text style={styles.text}>
        {text.repeat(10)}
      </Text>
    </ScrollView>

    <View
      pointerEvents={'none'}
      style={styles.top}
    >
      <BlurView
        fadeStyle={'bottom'}
        fadePercent={1}
        blurIntensity={4}
        style={StyleSheet.absoluteFill}
      />
    </View>

    <View
      pointerEvents={'none'}
      style={styles.bottom}
    >
      <BlurView
        fadePercent={1}
        blurIntensity={4}
        style={StyleSheet.absoluteFill}
      />
    </View>
  </>
);

const TOP_INSET = 70;
const BOTTOM_INSET = 60;

const styles = StyleSheet.create({
  bottom: {
    position: 'absolute',
    overflow: 'hidden',

    left: 0, right: 0,
    bottom: 0, height: BOTTOM_INSET,
  },
  top: {
    position: 'absolute',
    overflow: 'hidden',

    left: 0, right: 0,
    top: 0, height: TOP_INSET,
  },
  text: {
    marginHorizontal: 20,
    marginBottom: 40,
    color: consts.color.text.dynamic,
    fontSize: 18,
    lineHeight: 28,
  },
});

const text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
