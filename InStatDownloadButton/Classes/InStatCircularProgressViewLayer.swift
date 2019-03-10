//
//  InStatCircularProgressViewLayer.swift
//  InStatDownloadButton
//

import UIKit

public class InStatCircularProgressViewLayer: CALayer {

	@NSManaged var angle: Double
	var radius: CGFloat = 0 {
		didSet {
			invalidateGradientCache()
		}
	}
	var startAngle: Double = 0
	var clockwise: Bool = true {
		didSet {
			if clockwise != oldValue {
				invalidateGradientCache()
			}
		}
	}
	
	var roundedCorners: Bool = true
	var lerpColorMode: Bool = false
	var gradientRotateSpeed: CGFloat = 0 {
		didSet {
			invalidateGradientCache()
		}
	}
	var glowAmount: CGFloat = 0
	var glowMode: GlowMode = .forward
	var progressThickness: CGFloat = 0.5
	var trackThickness: CGFloat = 0.5
	var trackColor: UIColor = .black
	var progressInsideFillColor: UIColor = .clear
	var colorsArray: [UIColor] = [] {
		didSet {
			invalidateGradientCache()
		}
	}
	
	private var gradientCache: CGGradient?
	private var locationsCache: [CGFloat]?

	private enum GlowConstants {
		private static let sizeToGlowRatio: CGFloat = 0.00015
		static func glowAmount(forAngle angle: Double, glowAmount: CGFloat, glowMode: GlowMode, size: CGFloat) -> CGFloat {
			switch glowMode {
			case .forward:
				return CGFloat(angle) * size * sizeToGlowRatio * glowAmount
			case .reverse:
				return CGFloat(360 - angle) * size * sizeToGlowRatio * glowAmount
			case .constant:
				return 360 * size * sizeToGlowRatio * glowAmount
			default:
				return 0
			}
		}
	}

	override public class func needsDisplay(forKey key: String) -> Bool {
		return key == "angle" ? true : super.needsDisplay(forKey: key)
	}

	override init(layer: Any) {
		super.init(layer: layer)
		
		let progressLayer = layer as! InStatCircularProgressViewLayer
		radius = progressLayer.radius
		angle = progressLayer.angle
		startAngle = progressLayer.startAngle
		clockwise = progressLayer.clockwise
		roundedCorners = progressLayer.roundedCorners
		lerpColorMode = progressLayer.lerpColorMode
		gradientRotateSpeed = progressLayer.gradientRotateSpeed
		glowAmount = progressLayer.glowAmount
		glowMode = progressLayer.glowMode
		progressThickness = progressLayer.progressThickness
		trackThickness = progressLayer.trackThickness
		trackColor = progressLayer.trackColor
		colorsArray = progressLayer.colorsArray
		progressInsideFillColor = progressLayer.progressInsideFillColor


	}

	override init() {
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override public func draw(in ctx: CGContext) {
		UIGraphicsPushContext(ctx)

		let size = bounds.size
		let width = size.width
		let height = size.height

		let trackLineWidth = radius * trackThickness
		let progressLineWidth = radius * progressThickness
		let arcRadius = max(radius - trackLineWidth / 2, radius - progressLineWidth / 2)
		ctx.addArc(center: CGPoint(x: width / 2.0, y: height / 2.0), radius: arcRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
		trackColor.set()
		ctx.setStrokeColor(trackColor.cgColor)
		ctx.setFillColor(progressInsideFillColor.cgColor)
		ctx.setLineWidth(trackLineWidth)
		ctx.setLineCap(CGLineCap.butt)
		ctx.drawPath(using: .fillStroke)

		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

		let imageCtx = UIGraphicsGetCurrentContext()
		let reducedAngle = Utility.mod(value: angle, range: 360, minMax: (0, 360))
		let fromAngle = Conversion.degreesToRadians(value: CGFloat(-startAngle))
		let toAngle = Conversion.degreesToRadians(value: CGFloat((clockwise == true ? -reducedAngle : reducedAngle) - startAngle))

		imageCtx?.addArc(center: CGPoint(x: width / 2.0, y: height / 2.0), radius: arcRadius, startAngle: fromAngle, endAngle: toAngle, clockwise: clockwise)

		let glowValue = GlowConstants.glowAmount(forAngle: reducedAngle, glowAmount: glowAmount, glowMode: glowMode, size: width)
		if glowValue > 0 {
			imageCtx?.setShadow(offset: CGSize.zero, blur: glowValue, color: UIColor.black.cgColor)
		}

		let linecap: CGLineCap = roundedCorners ? .round : .butt
		imageCtx?.setLineCap(linecap)
		imageCtx?.setLineWidth(progressLineWidth)
		imageCtx?.drawPath(using: .stroke)

		let drawMask: CGImage = UIGraphicsGetCurrentContext()!.makeImage()!
		UIGraphicsEndImageContext()

		ctx.saveGState()
		ctx.clip(to: bounds, mask: drawMask)

		//Gradient - Fill
		if !lerpColorMode, colorsArray.count > 1 {
			let rgbColorsArray: [UIColor] = colorsArray.map { color in // Make sure every color in colors array is in RGB color space
				if color.cgColor.numberOfComponents == 2 {
					if let whiteValue = color.cgColor.components?[0] {
						return UIColor(red: whiteValue, green: whiteValue, blue: whiteValue, alpha: 1.0)
					} else {
						return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
					}
				} else {
					return color
				}
			}

			let componentsArray = rgbColorsArray.flatMap { color -> [CGFloat] in
				guard let components = color.cgColor.components else { return [] }
				return [components[0], components[1], components[2], 1.0]
			}

			drawGradientWith(context: ctx, componentsArray: componentsArray)
		} else {
			var color: UIColor?
			if colorsArray.isEmpty {
				color = .white
			} else if colorsArray.count == 1 {
				color = colorsArray[0]
			} else {
				// lerpColorMode is true
				let t = CGFloat(reducedAngle) / 360
				let steps = colorsArray.count - 1
				let step = 1 / CGFloat(steps)
				for i in 1...steps {
					let fi = CGFloat(i)
					if (t <= fi * step || i == steps) {
						let colorT = Utility.inverseLerp(value: t, minMax: ((fi - 1) * step, fi * step))
						color = Utility.colorLerp(value: colorT, minMax: (colorsArray[i - 1], colorsArray[i]))
						break
					}
				}
			}

			color.map { fillRectWith(context: ctx, color: $0) }
		}

		ctx.restoreGState()
		UIGraphicsPopContext()
	}

	private func fillRectWith(context: CGContext!, color: UIColor) {
		context.setFillColor(color.cgColor)
		context.fill(bounds)
	}

	private func drawGradientWith(context: CGContext!, componentsArray: [CGFloat]) {
		let baseSpace = CGColorSpaceCreateDeviceRGB()
		let locations = locationsCache ?? gradientLocationsFor(colorCount: componentsArray.count / 4, gradientWidth: bounds.size.width)
		let gradient: CGGradient

		if let cachedGradient = gradientCache {
			gradient = cachedGradient
		} else {
			guard let cachedGradient = CGGradient(colorSpace: baseSpace, colorComponents: componentsArray, locations: locations, count: componentsArray.count / 4) else {
				return
			}

			gradientCache = cachedGradient
			gradient = cachedGradient
		}

		let halfX = bounds.size.width / 2.0
		let floatPi = CGFloat.pi
		let rotateSpeed = clockwise == true ? gradientRotateSpeed : gradientRotateSpeed * -1
		let angleInRadians = Conversion.degreesToRadians(value: rotateSpeed * CGFloat(angle) - 90)
		let oppositeAngle = angleInRadians > floatPi ? angleInRadians - floatPi : angleInRadians + floatPi

		let startPoint = CGPoint(x: (cos(angleInRadians) * halfX) + halfX, y: (sin(angleInRadians) * halfX) + halfX)
		let endPoint = CGPoint(x: (cos(oppositeAngle) * halfX) + halfX, y: (sin(oppositeAngle) * halfX) + halfX)

		context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
	}

	private func gradientLocationsFor(colorCount: Int, gradientWidth: CGFloat) -> [CGFloat] {
		if colorCount == 0 || gradientWidth == 0 {
			return []
		} else {
			let progressLineWidth = radius * progressThickness
			let firstPoint = gradientWidth / 2 - (radius - progressLineWidth / 2)
			let increment = (gradientWidth - (2 * firstPoint)) / CGFloat(colorCount - 1)

			let locationsArray = (0..<colorCount).map { firstPoint + (CGFloat($0) * increment) }
			let result = locationsArray.map { $0 / gradientWidth }
			locationsCache = result
			return result
		}
	}

	private func invalidateGradientCache() {
		gradientCache = nil
		locationsCache = nil
	}
}
