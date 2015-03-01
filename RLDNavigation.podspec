Pod::Spec.new do |s|
  s.name         = 'RLDNavigation'
  s.version      = '0.1.0'
  s.homepage     = 'https://github.com/tuenti/RLDNavigation'
  s.summary      = 'Framework to decouple navigation from view controllers'
  s.authors      = { 'Rafael Lopez Diez' => 'https://twitter.com/rafalopezdiez' }
  s.source       = { :git => 'https://github.com/rlopezdiez/RLDNavigation.git', :tag => s.version.to_s }
  s.source_files = 'Classes/*.{h,m}'
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.requires_arc = true
end
