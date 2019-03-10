//
//  ComparableExtension.swift
//  InStatDownloadButton
//

extension Comparable {
	func clamped(toMinimum minimum: Self, maximum: Self) -> Self {
		assert(maximum >= minimum, "Maximum clamp value can't be higher than the minimum")
		if self < minimum {
			return minimum
		} else if self > maximum {
			return maximum
		} else {
			return self
		}
	}
}
