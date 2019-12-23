#
# Be sure to run `pod lib lint UIContainer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIContainer'
  s.version          = '1.2.0-beta.2'
  s.summary          = 'Creating containers for UIViewController, UIView, UITableViewCell and UICollectionViewCell'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
UIContainer helps by allowing you to keep the code more specific. You can write code for view controllers like AddressesViewController and for view AddressView that can be used in ProfileViewController and in the AddressesViewController using the ContainerTableViewCell<AddressView> wrapper. This should decrease the excess of code for the same data but in different view controllers.
                       DESC

  s.homepage         = 'https://github.com/umobi/UIContainer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brennobemoura@outlook.com' }
  s.source           = { :git => 'https://github.com/umobi/UIContainer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.1'

  s.source_files = 'UIContainer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'UIContainer' => ['UIContainer/Assets/*.png']
  # }
  
  s.dependency 'SnapKit', '~> 5.0.1'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
