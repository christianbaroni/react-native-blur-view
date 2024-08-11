func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
  return Swift.max(min, Swift.min(max, value))
}
