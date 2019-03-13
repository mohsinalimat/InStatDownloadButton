//
//  ViewController.swift
//  InStatDownloadButton
//
//  Created by tularovbeslan@gmail.com on 03/10/2019.
//  Copyright (c) 2019 tularovbeslan@gmail.com. All rights reserved.
//

import UIKit
import InStatDownloadButton

class ViewController: UIViewController {

	@IBOutlet weak var downloadButton: InStatDownloadButton!
	@IBOutlet weak var segmentedControl: UISegmentedControl!

	override func viewDidLoad() {
		super.viewDidLoad()

		setupProgressView()
		setupIndicatorView()
	}

	@IBAction func changeState(_ sender: UISegmentedControl) {

		switch sender.selectedSegmentIndex {
		case 0:
			downloadButton.downloadState = .start
		case 1:
			downloadButton.downloadState = .pending
		case 2:
			downloadButton.downloadState = .downloading
			downloadButton.progressView.animate(fromAngle: 0, toAngle: 360, duration: 2) { _ in
				self.segmentedControl.selectedSegmentIndex = 4
				self.downloadButton.downloadState = .finish
			}
		case 3:
			downloadButton.downloadState = .stop

		case 4:
			downloadButton.downloadState = .finish
		default: break
		}
	}

	func setupProgressView() {

		downloadButton.progressView.startAngle = -90
		downloadButton.progressView.progressThickness = 0.2
		downloadButton.progressView.trackThickness = 0.6
		downloadButton.progressView.clockwise = true
		downloadButton.progressView.gradientRotateSpeed = 2
		downloadButton.progressView.roundedCorners = false
		downloadButton.progressView.glowMode = .forward
		downloadButton.progressView.glowAmount = 0.9
		downloadButton.progressView.stopColor = UIColor.red.cgColor
		downloadButton.progressView.set(colors: UIColor.cyan, UIColor.orange)
	}

	func setupIndicatorView() {

		downloadButton.indicatorView.startAngle = -90
		downloadButton.indicatorView.progressThickness = 0.2
		downloadButton.indicatorView.trackThickness = 0.6
		downloadButton.indicatorView.gradientRotateSpeed = 2
		downloadButton.indicatorView.roundedCorners = false
		downloadButton.indicatorView.glowMode = .forward
		downloadButton.indicatorView.glowAmount = 0.9
		downloadButton.indicatorView.set(colors: UIColor.cyan)
		downloadButton.indicatorView.trackColor = .black
	}
}

