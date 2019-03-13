# InStatDownloadButton 

![IMG_1268 TRIM 2019-03-12 16_27_11](https://user-images.githubusercontent.com/4906243/54244155-65377b80-453c-11e9-8303-d24289b855b8.gif)


[![CI Status](https://img.shields.io/travis/tularovbeslan@gmail.com/InStatDownloadButton.svg?style=flat)](https://travis-ci.org/tularovbeslan@gmail.com/InStatDownloadButton)
[![Version](https://img.shields.io/cocoapods/v/InStatDownloadButton.svg?style=flat)](https://cocoapods.org/pods/InStatDownloadButton)
[![License](https://img.shields.io/cocoapods/l/InStatDownloadButton.svg?style=flat)](https://cocoapods.org/pods/InStatDownloadButton)
[![Platform](https://img.shields.io/cocoapods/p/InStatDownloadButton.svg?style=flat)](https://cocoapods.org/pods/InStatDownloadButton)

## Customize

```
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
```

```
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
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

InStatDownloadButton is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InStatDownloadButton'
```

## Author

tularovbeslan@gmail.com

## License

InStatDownloadButton is available under the MIT license. See the LICENSE file for more info.
