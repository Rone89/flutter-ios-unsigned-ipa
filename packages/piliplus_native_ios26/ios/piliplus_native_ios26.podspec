Pod::Spec.new do |s|
  s.name             = 'piliplus_native_ios26'
  s.version          = '0.1.0'
  s.summary          = 'Native iOS 26 Liquid Glass SwiftUI surfaces for Flutter.'
  s.description      = 'Provides SwiftUI PlatformView surfaces with iOS 26 Liquid Glass styling and fallbacks.'
  s.homepage         = 'https://example.invalid/piliplus_native_ios26'
  s.license          = { :type => 'MIT' }
  s.author           = { 'PiliPlus' => 'dev@example.invalid' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '15.0'
  s.swift_version    = '5.10'
end
