enum FadeStyle {
	case bottom
	case top
	case left
	case right
	
	static func from(style: NSString) -> FadeStyle {
		switch style {
			case "bottom":
				return .bottom
			case "top":
				return .top
			case "left":
				return .left
			case "right":
				return .right
			default:
				return .bottom
		}
	}
}

extension UIView {
	func fadeView(style: FadeStyle = .bottom, percentage: Double = 0.07) {
		let gradient = CAGradientLayer()
		gradient.frame = bounds
		gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
		
		let startLocation = percentage
		let endLocation = 1 - percentage
		
		switch style {
			case .bottom:
				gradient.startPoint = CGPoint(x: 0.5, y: endLocation)
				gradient.endPoint = CGPoint(x: 0.5, y: 1)
			case .top:
				gradient.startPoint = CGPoint(x: 0.5, y: startLocation)
				gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
			case .left:
				gradient.startPoint = CGPoint(x: startLocation, y: 0.5)
				gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
			case .right:
				gradient.startPoint = CGPoint(x: endLocation, y: 0.5)
				gradient.endPoint = CGPoint(x: 1, y: 0.5)
		}
		
		layer.mask = gradient
	}
	
}
