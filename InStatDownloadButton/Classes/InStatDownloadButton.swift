//
//  InStatDownloadButton.swift
//  InStatDownloadButton
//

import UIKit

public class InStatDownloadButton: UIButton {

	// MARK: - Properties

	public var progressDuration: TimeInterval = 0

	public var downloadState: InStatDownloadButtonState = .start {
		didSet {

			switch downloadState {
			case .start:
				indicatorView.removeFromSuperview()
				progressView.removeFromSuperview()
				self.setImage(image, for: .normal)

			case .pending:
				setImage(nil, for: .normal)
				progressView.removeFromSuperview()
				addSubview(indicatorView)
				setupIndicatorConstraints()
				indicatorView.startSpinning()

			case .downloading:
				indicatorView.removeFromSuperview()
				setImage(nil, for: .normal)
				addSubview(progressView)
				setupProgressConstraints()

			case .finish:
				setImage(nil, for: .normal)
				indicatorView.removeFromSuperview()
				progressView.removeFromSuperview()
			}
		}
	}

	// MARK: - UI

	public var progressView: InStatCircularProgress = {

		let view = InStatCircularProgress()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.startAngle = -90
		view.progressThickness = 0.4
		view.trackThickness = 0.4
		view.clockwise = true
		view.set(colors: Color.Blue.medium)
		view.trackColor = Color.Gray.medium
		return view
	}()

	public let indicatorView: InStatPendingIndicator = {

		let view = InStatPendingIndicator()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.startAngle = -90
		view.progress = 270
		view.progressThickness = 0.4
		view.trackThickness = 0.4
		view.set(colors: Color.Gray.dark)
		return view
	}()

	fileprivate var image: UIImage?


	// MARK: - Init

	override public func awakeFromNib() {
		super.awakeFromNib()

		image = image(for: .normal)
	}

	// MARK: - Setup

	fileprivate func setupIndicatorConstraints() {

		indicatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		indicatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		indicatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}

	fileprivate func setupProgressConstraints() {

		progressView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		progressView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		progressView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		progressView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
}
