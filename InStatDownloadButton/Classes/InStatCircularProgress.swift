//
//  InStatCircularProgress.swift
//  InStatDownloadButton
//

import UIKit

public class InStatCircularProgress: UIView, CAAnimationDelegate {

	private let stopLayer: CALayer = CALayer()

	private var progressLayer: InStatCircularProgressViewLayer {
		get {
			return layer as! InStatCircularProgressViewLayer
		}
	}

	private var radius: CGFloat = 0 {
		didSet {
			progressLayer.radius = radius
		}
	}

	public var progress: Double = 0 {
		didSet {
			let clampedProgress = progress.clamped(toMinimum: 0, maximum: 1)
			angle = 360 * clampedProgress
		}
	}

	public var angle: Double = 0 {
		didSet {
			if self.isAnimating() {
				self.pauseAnimation()
			}
			progressLayer.angle = angle
		}
	}

	public var startAngle: Double = 0 {
		didSet {
			startAngle = Utility.mod(value: startAngle, range: 360, minMax: (0, 360))
			progressLayer.startAngle = startAngle
			progressLayer.setNeedsDisplay()
		}
	}

	public var clockwise: Bool = true {
		didSet {
			progressLayer.clockwise = clockwise
			progressLayer.setNeedsDisplay()
		}
	}

	public var roundedCorners: Bool = true {
		didSet {
			progressLayer.roundedCorners = roundedCorners
		}
	}

	public var lerpColorMode: Bool = false {
		didSet {
			progressLayer.lerpColorMode = lerpColorMode
		}
	}

	public var gradientRotateSpeed: CGFloat = 0 {
		didSet {
			progressLayer.gradientRotateSpeed = gradientRotateSpeed
		}
	}

	public var glowAmount: CGFloat = 1.0 {//Between 0 and 1
		didSet {
			glowAmount = glowAmount.clamped(toMinimum: 0, maximum: 1)
			progressLayer.glowAmount = glowAmount
		}
	}

	public var glowMode: GlowMode = .noGlow {
		didSet {
			progressLayer.glowMode = glowMode
		}
	}

	public var progressThickness: CGFloat = 0.4 {//Between 0 and 1
		didSet {
			progressThickness = progressThickness.clamped(toMinimum: 0, maximum: 1)
			progressLayer.progressThickness = progressThickness / 2
		}
	}

	public var trackThickness: CGFloat = 0.5 {//Between 0 and 1
		didSet {
			trackThickness = trackThickness.clamped(toMinimum: 0, maximum: 1)
			progressLayer.trackThickness = trackThickness / 2
		}
	}

	public var trackColor: UIColor = .white {
		didSet {
			progressLayer.trackColor = trackColor
			progressLayer.setNeedsDisplay()
		}
	}

	public var stopColor: CGColor = UIColor.blue.cgColor {
		didSet {
			stopLayer.backgroundColor = stopColor
			stopLayer.setNeedsDisplay()
		}
	}

	public var progressInsideFillColor: UIColor? = nil {
		didSet {
			progressLayer.progressInsideFillColor = progressInsideFillColor ?? .clear
		}
	}

	public var progressColors: [UIColor] {
		get {
			return progressLayer.colorsArray
		}

		set {
			set(colors: newValue)
		}
	}

	private var animationCompletionBlock: ((Bool) -> Void)?

	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		setInitialValues()
		refreshValues()
		layer.addSublayer(stopLayer)
	}

	convenience public init(frame:CGRect, colors: UIColor...) {
		self.init(frame: frame)
		set(colors: colors)
	}

	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		translatesAutoresizingMaskIntoConstraints = false

		setInitialValues()
		refreshValues()
		layer.addSublayer(stopLayer)
	}

	override public class var layerClass: AnyClass {
		return InStatCircularProgressViewLayer.self
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		radius = (frame.size.width / 2.0) * 0.8
		setupStopLayer()
	}

	private func setInitialValues() {
		radius = (frame.size.width / 2.0) * 0.8
		backgroundColor = .clear
		set(colors: .white, .cyan)
	}

	private func refreshValues() {

		progressLayer.angle = angle
		progressLayer.startAngle = startAngle
		progressLayer.clockwise = clockwise
		progressLayer.roundedCorners = roundedCorners
		progressLayer.lerpColorMode = lerpColorMode
		progressLayer.gradientRotateSpeed = gradientRotateSpeed
		progressLayer.glowAmount = glowAmount
		progressLayer.glowMode = glowMode
		progressLayer.progressThickness = progressThickness / 2
		progressLayer.trackColor = trackColor
		progressLayer.trackThickness = trackThickness / 2
	}

	public func set(colors: UIColor...) {
		set(colors: colors)
	}

	private func set(colors: [UIColor]) {
		
		progressLayer.colorsArray = colors
		progressLayer.setNeedsDisplay()
	}

	public func animate(fromAngle: Double, toAngle: Double, duration: TimeInterval, relativeDuration: Bool = true, completion: ((Bool) -> Void)?) {
		if isAnimating() {
			pauseAnimation()
		}

		let animationDuration: TimeInterval
		if relativeDuration {
			animationDuration = duration
		} else {
			let traveledAngle = Utility.mod(value: toAngle - fromAngle, range: 360, minMax: (0, 360))
			let scaledDuration = (TimeInterval(traveledAngle) * duration) / 360
			animationDuration = scaledDuration
		}

		let animation = CABasicAnimation(keyPath: "angle")
		animation.fromValue = fromAngle
		animation.toValue = toAngle
		animation.duration = animationDuration
		animation.delegate = self
		animation.isRemovedOnCompletion = false
		angle = toAngle
		animationCompletionBlock = completion

		progressLayer.add(animation, forKey: "angle")
	}

	public func animate(toAngle: Double, duration: TimeInterval, relativeDuration: Bool = true, completion: ((Bool) -> Void)?) {
		if isAnimating() {
			pauseAnimation()
		}
		animate(fromAngle: angle, toAngle: toAngle, duration: duration, relativeDuration: relativeDuration, completion: completion)
	}

	public func pauseAnimation() {
		guard let presentationLayer = progressLayer.presentation() else { return }

		let currentValue = presentationLayer.angle
		progressLayer.removeAllAnimations()
		angle = currentValue
	}

	public func stopAnimation() {
		progressLayer.removeAllAnimations()
		angle = 0
	}

	public func isAnimating() -> Bool {
		return progressLayer.animation(forKey: "angle") != nil
	}

	public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		if let completionBlock = animationCompletionBlock {
			animationCompletionBlock = nil
			completionBlock(flag)
		}
	}

	public override func didMoveToWindow() {
		if let window = window {
			progressLayer.contentsScale = window.screen.scale
		}
	}

	public override func willMove(toSuperview newSuperview: UIView?) {
		if newSuperview == nil && isAnimating() {
			pauseAnimation()
		}
	}

	public override func prepareForInterfaceBuilder() {
		setInitialValues()
		refreshValues()
		progressLayer.setNeedsDisplay()
	}

	func setupStopLayer() {

		stopLayer.backgroundColor = Color.Blue.medium.cgColor
		stopLayer.borderWidth = 0
		stopLayer.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width * 0.3, height: frame.height * 0.3)
		stopLayer.cornerRadius = stopLayer.frame.width * 0.15
		stopLayer.position = center
		stopLayer.backgroundColor = stopColor
	}
}
