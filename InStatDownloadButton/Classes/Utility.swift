//
//  Utility.swift
//  InStatDownloadButton
//

import UIKit

public enum Utility {
	
	static func inverseLerp(value: CGFloat, minMax: (CGFloat, CGFloat)) -> CGFloat {
		return (value - minMax.0) / (minMax.1 - minMax.0)
	}

	static func lerp(value: CGFloat, minMax: (CGFloat, CGFloat)) -> CGFloat {
		return (minMax.1 - minMax.0) * value + minMax.0
	}

	static func colorLerp(value: CGFloat, minMax: (UIColor, UIColor)) -> UIColor {
		let clampedValue = value.clamped(toMinimum: 0, maximum: 1)
		let zero = CGFloat(0)

		var (r0, g0, b0, a0) = (zero, zero, zero, zero)
		minMax.0.getRed(&r0, green: &g0, blue: &b0, alpha: &a0)

		var (r1, g1, b1, a1) = (zero, zero, zero, zero)
		minMax.1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)

		return UIColor(red: lerp(value: clampedValue, minMax: (r0, r1)), green: lerp(value: clampedValue, minMax: (g0, g1)), blue: lerp(value: clampedValue, minMax: (b0, b1)), alpha: lerp(value: clampedValue, minMax: (a0, a1)))
	}

	static func mod(value: Double, range: Double, minMax: (Double, Double)) -> Double {
		let (min, max) = minMax
		assert(abs(range) <= abs(max - min), "range should be <= than the interval")
		if value >= min && value <= max {
			return value
		} else if value < min {
			return mod(value: value + range, range: range, minMax: minMax)
		} else {
			return mod(value: value - range, range: range, minMax: minMax)
		}
	}
}
