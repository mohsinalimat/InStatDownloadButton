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

	var downloadTimer: Timer?

	override func viewDidLoad() {
		super.viewDidLoad()


	}

	func simulateDownloading() {
		var angle: Double = 0
		downloadTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
			angle += 10

			self.downloadButton.progressView.angle = angle
		}
		downloadTimer?.fire()
	}

	@IBAction func changeState(_ sender: UISegmentedControl) {
		downloadTimer?.invalidate()
		switch sender.selectedSegmentIndex {
		case 0:
			downloadButton.downloadState = .start
		case 1:
			downloadButton.downloadState = .pending
		case 2:
			downloadButton.downloadState = .downloading
			simulateDownloading()
		case 3:
			downloadButton.downloadState = .finish
		default:
			break
		}
	}
}

