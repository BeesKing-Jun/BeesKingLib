#
# Be sure to run `pod lib lint BeesKingLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BeesKingLib'
  s.version          =  '0.0.5'
  s.summary          = 'A short description of BeesKingLib.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/s18782934812/BeesKingLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 's18782934812' => '836152122@qq.com' }
  s.source           = { :git => 'https://github.com/s18782934812/BeesKingLib.git', :tag => s.version.to_s }
  
  s.subspec 'BeesKingCommon' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.source_files = 'BeesKingLib/BKCommon/**/*.{h,m}'
    ss.frameworks = 'UIKit','Foundation'
  end
  
  s.subspec 'BeesKingNetWork' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.source_files = 'BeesKingLib/BKNetWork/**/*.{h,m,mm}'
    ss.frameworks = 'UIKit','Foundation'
  end
  
  s.subspec 'BessKingMediator' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.ios.source_files = 'BeesKingLib/BKMediator/**/*.{h,m,mm}'
    ss.ios.frameworks = 'UIKit','Foundation'
end


