#
#  Be sure to run `pod spec lint SSAppUpdater.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

 Pod::Spec.new do |s|
  s.name         = "SSPullToRefresh"
  s.version      = "0.1.0"
  s.summary      = "SSPullToRefresh is an open-source library that uses UIKit to add an animation to the pull to refresh view in a UITableView and UICollectionView."


  s.homepage     = 'https://github.com/mobile-simformsolutions/SSPullToRefresh.git'
  
  #s.license      = "MIT"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "Simform Solutions" => "developer@simform.com" }
  s.platform     = :ios  
  
  s.ios.deployment_target = "10.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/mobile-simformsolutions/SSPullToRefresh.git", :tag => "#{s.version}" }
  #s.source       = { :path => ".", :tag => "#{s.version}" }

  s.source_files  = 'SSPullToRefresh/**/*.swift'
  #s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  s.documentation_url = 'docs/index.html'

end
