#
# Be sure to run `pod lib lint InStatDownloadButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'InStatDownloadButton'
  s.version          = '1.0.0'
  s.summary          = 'InStatDownloadButton - progressive'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
	InStatDownloadButton with indicator/progress
                       DESC

  s.homepage         = 'https://github.com/tularovbeslan/InStatDownloadButton'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tularovbeslan@gmail.com' => 'tularovbeslan@gmail.com' }
  s.source           = { :git => 'https://github.com/tularovbeslan/InStatDownloadButton.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/JiromTomson'
  s.swift_version = '4.2'
  s.ios.deployment_target = '10.0'

  s.source_files = 'InStatDownloadButton/Classes/**/*'
  s.frameworks = 'UIKit', 'MapKit'
end
