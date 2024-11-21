extension UIBlurEffect.Style {
  static func from(string: NSString) -> UIBlurEffect.Style {
    switch string {
    case "extraLight":
      return .extraLight
    case "light":
      return .light
    case "dark":
      return .dark
    case "regular":
      return .regular
    case "prominent":
      return .prominent

// These aren't supported yet
//
//    case "ultraThinMaterial":
//      return .systemUltraThinMaterial
//    case "thinMaterial":
//      return .systemThinMaterial
//    case "material":
//      return .systemMaterial
//    case "thickMaterial":
//      return .systemThickMaterial
//    case "chromeMaterial":
//      return .systemChromeMaterial
//    case "ultraThinMaterialLight":
//      return .systemUltraThinMaterialLight
//    case "thinMaterialLight":
//      return .systemThinMaterialLight
//    case "materialLight":
//      return .systemMaterialLight
//    case "thickMaterialLight":
//      return .systemThickMaterialLight
//    case "chromeMaterialLight":
//      return .systemChromeMaterialLight
//    case "ultraThinMaterialDark":
//      return .systemUltraThinMaterialDark
//    case "thinMaterialDark":
//      return .systemThinMaterialDark
//    case "materialDark":
//      return .systemMaterialDark
//    case "thickMaterialDark":
//      return .systemThickMaterialDark
//    case "chromeMaterialDark":
//      return .systemChromeMaterialDark
    default:
      return .regular
    }
  }
}
