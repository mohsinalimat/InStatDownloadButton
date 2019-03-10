//
//  InStatPendingIndicator.swift
//  InStatDownloadButton
//

import UIKit

public class InStatPendingIndicator: UIView, CAAnimationDelegate {

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
			angle = progress
		}
	}

	public var duration: Double = 1.5 {
		didSet {
			startSpinning()
		}
	}

	public var angle: Double = 0 {
		didSet {
			progressLayer.angle = angle
		}
	}

	public var startAngle: Double = 0 {
		didSet {
			progressLayer.startAngle = startAngle
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

	public var glowAmount: CGFloat = 1.0 {
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

	public var progressThickness: CGFloat = 0.4 {
		didSet {
			progressThickness = progressThickness.clamped(toMinimum: 0, maximum: 1)
			progressLayer.progressThickness = progressThickness / 2
		}
	}

	public var trackThickness: CGFloat = 0.5 {
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
	}

	override public class var layerClass: AnyClass {
		return InStatCircularProgressViewLayer.self
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		radius = (frame.size.width / 2.0) * 0.8
	}

	private func setInitialValues() {
		radius = (frame.size.width / 2.0) * 0.8
		backgroundColor = .clear
		set(colors: .white, .cyan)
	}

	private func refreshValues() {

		progressLayer.angle = angle
		progressLayer.startAngle = startAngle
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

	public override func prepareForInterfaceBuilder() {
		setInitialValues()
		refreshValues()
		progressLayer.setNeedsDisplay()
	}

	func startSpinning() {
		let animationKey = "rotation"
		layer.removeAnimation(forKey: animationKey)
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotationAnimation.fromValue = 0.0
		rotationAnimation.toValue = CGFloat.pi * 2
		rotationAnimation.duration = duration
		rotationAnimation.repeatCount = .greatestFiniteMagnitude;
		progressLayer.add(rotationAnimation, forKey: animationKey)
	}
}

