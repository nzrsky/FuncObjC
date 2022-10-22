#
# Be sure to run `pod lib lint FunkObjC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = 'FunkObjC'
  s.version      = '0.2.1'
  s.summary      = 'Functional ObjC extension'
  s.homepage     = 'https://github.com/nzrsky/FunkObjC'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Alexey Nazarov' => 'alexx.nazaroff@gmail.com' }
  s.source       = { :git => 'https://github.com/nzrsky/FunkObjC.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nzrsky'

  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '5.0'

  s.requires_arc = true  
  s.frameworks    = 'Foundation'
  
  s.source_files = "FunkObjC/**/*.{m,h}"
  
  pch_TARGETS = <<-EOS
#ifndef TARGET_OS_IOS
  #define TARGET_OS_IOS TARGET_OS_IPHONE
#endif
#ifndef TARGET_OS_WATCH
  #define TARGET_OS_WATCH 0
#endif
#ifndef TARGET_OS_TV
  #define TARGET_OS_TV 0
#endif
EOS
  s.prefix_header_contents = pch_TARGETS

  s.dependency 'ModernObjC', '>= 0.1.2'
end
