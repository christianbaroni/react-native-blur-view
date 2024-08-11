import { Dimensions, DynamicColorIOS } from 'react-native';

export default {
  color: {
    accent: DynamicColorIOS({
      dark: '#a64747',
      light: '#ff7777',
    }),
    text: {
      light: '#eee',
      dark: '#333',
      dynamic: DynamicColorIOS({
        dark: '#ddd',
        light: '#444',
      }),
    },
  },
  screen: {
    width: Dimensions.get('window').width,
    height: Dimensions.get('window').height,
  },
};
