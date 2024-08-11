# react-native-blur-view

> ⚠️ Package isn’t published to npm yet and probably won’t be. **It uses Apple’s private API** and might be
> the reason for App Store rejection. Use it at your own risk.

React Native blur view that extends standard iOS `UIVisualEffectView`. Besides regular blur styles (light, dark, etc.) 
it unlocks control over blur and saturation intensity, and provides **two additional styles**:
- **variable**: blur with gradient mask and customizable gradient points
- **plain**: clean gaussian blur without any additional effects (saturation, tint, grain etc.)

| |  |
|------------------------------------------------------------------------------------------|-------|
| <img width="246" alt="1" src="https://github.com/user-attachments/assets/7ab36d8c-9735-4782-b31f-b3612f129fb1"> | <img width="246" alt="2" src="https://github.com/user-attachments/assets/836c0cbb-a148-483b-95bd-d5e4d8d16b1a">|

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

| Name                  | Type                                                                        | Default     | Description                                                                                                                        |
|-----------------------|-----------------------------------------------------------------------------|-------------|------------------------------------------------------------------------------------------------------------------------------------|
| `blurStyle`           | `variable \| plain \| regular \| light \| 'variable' \| extraLight \| dark` | `variable`  | Blur style.                                                                                                                        |
| `blurIntensity`       | `number`                                                                    | `10.0`      | Blur intensity. Varies from `0.0` to `100.0`                                                                                       |
| `saturationIntensity` | `number`                                                                    | `1.0`       | Saturation intensity. Varies from `0.0` to `3.0`                                                                                   |
| `gradientPoints`      | `[{ x: number, y: number }, { x: number, y: number }]`                                              | `undefined` | Gradient points for `variable` blur style. If not provided, gradient mask will be stretched to view height in bottom-top direction |
| `style`               | `ViewStyle`                                                                 | `undefined` | Style for the view.                                                                                                                |

