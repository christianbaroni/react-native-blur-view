# react-native-blur-view

> ⚠️ Package isn’t published to npm yet and probably won’t be. **It uses Apple’s private API** and might be
> the reason for App Store rejection. Use it at your own risk.

> ⚠️ **iOS only**

React Native blur view that extends standard iOS `UIVisualEffectView`. Besides regular blur styles (light, dark, etc.)
it unlocks control over blur and saturation intensity, and provides **two additional styles**:

- **variable**: blur with gradient mask and customizable gradient points
- **plain**: clean gaussian blur without any additional effects (saturation, tint, grain etc.)

| <video src="https://github.com/user-attachments/assets/7ab36d8c-9735-4782-b31f-b3612f129fb1"> | <video src="https://github.com/user-attachments/assets/836c0cbb-a148-483b-95bd-d5e4d8d16b1a"> |
|-----------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|

If you still want to use it, you can install it directly from GitHub. Add following to your `package.json`:

```json
"dependencies": {
  "react-native-blur-view": "https://github.com/kirgudkov/react-native-blur-view.git"
}
```

run `yarn install` or `npm install` and then run `pod install`

## Usage

```jsx
import { BlurView } from 'react-native-blur-view';

<View style={styles.container}>
  <Text>Blurred content</Text>
  <BlurView
    style={StyleSheet.absoluteFill}
  />
</View>
```

## Props

- `blurStyle?: plain | extraLight | light | dark | regular | prominent` 
  - default: `regular`
- `blurIntensity?: [0.0, 100.0]` 
  - default: `10`
- `saturationIntensity?: [0.0, 3.0]` 
  - default: `1`
- `fadePercent?: [0.0, 1.0]` 
  - default: `0`
- `fadeStyle?: bottom | top | left | right` 
  - default: `top`
- `style?: StyleProp<ViewStyle>`
  - default: `undefined`
