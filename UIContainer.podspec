#
# Be sure to run `pod lib lint UIContainer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIContainer'
  s.version          = '2.2.0'
  s.summary          = 'Creating containers for UIViewController, UIView, UITableViewCell and UICollectionViewCell'
  s.homepage         = 'https://github.com/umobi/UIContainer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/UIContainer.git', :tag => s.version.to_s }

  s.description      = <<-DESC
  UIContainer helps by allowing you to keep the code more specific. You can write code for view controllers like AddressesViewController and for view AddressView that can be used in ProfileViewController and in the AddressesViewController using the ContainerTableViewCell<AddressView> wrapper. This should decrease the excess of code for the same data but in different view controllers.
                         DESC

  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  # s.macos.deployment_target = "10.13"
  s.swift_version = '5.2'

  s.source_files = 'Sources/UIContainer/**/*'

  s.dependency 'ConstraintBuilder', ">= 2.0.0", "< 3.0.0"
  
end
