Pod::Spec.new do |s|
  s.name         = 'RLDNavigation'
  s.version      = '0.1.0'
  s.homepage     = 'https://github.com/rlopezdiez/RLDNavigation.git'
  s.summary      = 'Framework to decouple navigation from view controllers'
  s.authors      = { 'Rafael Lopez Diez' => 'https://www.linkedin.com/in/rafalopezdiez' }
  s.source       = { :git => 'https://github.com/rlopezdiez/RLDNavigation.git', :tag => s.version.to_s }
  s.source_files = 'Classes/*.{h,m}'
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.platform     = :ios
  s.requires_arc = true
end
