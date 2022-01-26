
Pod::Spec.new do |s|
  s.name    = 'BSKAppCore'
<<<<<<< HEAD
  s.version = '2.0.0'
=======
  s.version = '0.1.0'
>>>>>>> 4d744fb54fb353563acc78bc4be8fd4626551e8f
  s.summary = 'An APP base Framework to help me start a project quickly.'

  s.description = <<-DESC 
                  BSKAppCore include some tools and frameworks which is required to create an normal APP.
                  * With this，so I can start write a project very quickly.
                  DESC
  
  s.homepage = 'https://www.liuwanlin.cn'
  
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.authors            = { "BlueSky335" => "chinabluesky335@gmail.com" }

  s.swift_version = "5.0"
  
  s.ios.deployment_target = "13.0"

  s.source       = { :git => "https://github.com/bluesky335/BSKAppCore.git", :tag => s.version }
  s.source_files  = ["Sources/**/*.swift", "Sources/BSKAppCore.h"]
  s.resource_bundles = {
    'LocalizationString' => ["Sources/**/*.strings"],
    'JsonFiles' => ["Sources/**/*.json"]
}
  s.public_header_files = ["Sources/BSKAppCore.h"]
  s.requires_arc = true
<<<<<<< HEAD
=======


  s.dependency 'BSKNetwork','~> 0.1.5.2'
  s.dependency 'BSKConsole','~> 0.1.0'
  s.dependency 'SnapKit'
  s.dependency 'QMUIKit','~> 4.0.2'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
>>>>>>> 4d744fb54fb353563acc78bc4be8fd4626551e8f
  
end
