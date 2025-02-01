//
//  CIContextManager.swift
//  react-native-blur-view
//
//  Created by Christian Baroni on 1/14/25.
//

import Foundation
import Metal
import CoreImage

struct CIContextManager {
  static let shared: CIContext = {
    // Attempt to create a Metal-backed context
    if let device = MTLCreateSystemDefaultDevice() {
      return CIContext(
        mtlDevice: device,
        options: [
          .cacheIntermediates: false,
          .useSoftwareRenderer: false,
        ]
      )
    } else {
      // Fallback: software-based if no Metal
      return CIContext(
        options: [
          .cacheIntermediates: false,
          .useSoftwareRenderer: false,
        ]
      )
    }
  }()
}
