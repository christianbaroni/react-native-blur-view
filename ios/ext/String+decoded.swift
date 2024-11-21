extension String {
  func base64Decoded() -> String {
    return String(decoding: Data(base64Encoded: self)!, as: Unicode.UTF8.self)
  }
}
