struct GradientPoints {

  var point0: CGPoint
  var point1: CGPoint
  
  init?(from array: NSArray?) {
    point0 = CGPoint(x: 0, y: 0)
    point1 = CGPoint(x: 0, y: 0)

    guard let array = array else {
      return
    }
    
    guard array.count == 2 else {
      print("Expected 2 points, got \(array.count)")
      return nil
    }
  
    point0.x = (array[0] as! NSDictionary)["x"] as! CGFloat
    point0.y = (array[0] as! NSDictionary)["y"] as! CGFloat
    point1.x = (array[1] as! NSDictionary)["x"] as! CGFloat
    point1.y = (array[1] as! NSDictionary)["y"] as! CGFloat
  }
}
