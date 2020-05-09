#
# Be sure to run `pod lib lint BeesKingLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BeesKingLib'
  s.version          =  '0.0.12'
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
  s.platform     = :ios, "8.0"
  
  s.subspec 'BKCommon' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.source_files = 'BeesKingLib/BKCommon/**/*.{h,m}'
    ss.frameworks = 'UIKit','Foundation'
  end
  s.subspec 'BKCategorys' do |ss|
    ss.ios.deployment_target = '8.0'
    
    ss.frameworks = 'UIKit','Foundation'
    ss.subspec 'BKCategory' do |sss|
      sss.ios.deployment_target = '8.0'
      sss.source_files = 'BeesKingLib/BKCategorys/BKCategory/*.{h,m}'
    end
    
    ss.subspec 'BKSafeCategory' do |sss|
      sss.ios.deployment_target = '8.0'
      sss.requires_arc = false
      sss.requires_arc = 'BeesKingLib/BKCategorys/BKSafeCategory/ARCSafe/*.{h,m}'
      sss.source_files = ['BeesKingLib/BKCategorys/BKSafeCategory/ARCSafe/*.{h,m}','BeesKingLib/BKCategorys/BKSafeCategory/*.{h,m}']
    end
  end
  
  s.subspec 'BKNetWork' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.source_files = 'BeesKingLib/BKNetWork/**/*.{h,m,mm}'
    ss.frameworks = 'UIKit','Foundation'
  end
  
  s.subspec 'BKMediator' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.ios.source_files = 'BeesKingLib/BKMediator/**/*.{h,m,mm}'
    ss.ios.frameworks = 'UIKit','Foundation'
  end
  s.source_files = 'BeesKingLib/BeesKingLib.h'
  s.public_header_files = 'BeesKingLib/BeesKingLib.h'
  s.dependency 'AFNetworking'
  
end


