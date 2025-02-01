import Foundation

func areArraysEqual(_ lhs: NSArray?, _ rhs: NSArray?) -> Bool {
    // Both nil or both non-nil and identical
    if lhs == nil && rhs == nil { return true }
    guard let lhs = lhs, let rhs = rhs else { return false }
    return lhs.isEqual(rhs)
} 