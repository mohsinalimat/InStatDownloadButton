//
//  Conversion.swift
//  InStatDownloadButton
//

import UIKit

public enum Conversion {
	static func degreesToRadians (value: CGFloat) -> CGFloat {
		return value * .pi / 180.0
	}
}
