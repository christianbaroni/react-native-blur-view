import { Dimensions, DynamicColorIOS } from "react-native";

export default {
  borderColor: DynamicColorIOS({
    light: "rgba(9, 17, 31, 0.04)",
    dark: "rgba(245, 248, 255, 0.08)",
  }),
  color: {
    accent: "#007AFF",
    text: {
      light: "#eee",
      dark: "#333",
      dynamic: DynamicColorIOS({
        dark: "#ddd",
        light: "#444",
      }),
    },
  },
  screen: {
    width: Dimensions.get("window").width,
    height: Dimensions.get("window").height,
  },
};
