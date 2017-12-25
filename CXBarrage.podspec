#
#  Be sure to run `pod spec lint CXBarrage.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "CXBarrage"
  s.version      = "0.0.1"
  s.summary      = "A Barrage View"
  s.description  = 'A barrage view to fire barrage in view'
  s.homepage     = "https://github.com/chuxia98/CXBarrage.git"
  s.license      = "MIT"
  s.author       = { "chuxia" => "875390793@qq.com" }
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/chuxia98/CXBarrage.git", :tag => "#{s.version}" }
  s.source_files  = "Barrage", "Barrage/CXBarrage/*.{h,m}"

end
