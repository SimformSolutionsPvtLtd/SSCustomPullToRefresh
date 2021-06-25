<a href="https://www.simform.com/"><img src="https://github.com/SimformSolutionsPvtLtd/SSToastMessage/blob/master/simformBanner.png"></a>
# SSCustomPullToRefresh


SSCustomPullToRefresh is an open-source library that uses UIKit to add an animation to the pull to refresh view in a UITableView and UICollectionView.

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![Carthage Compatible][carthage-image]][carthage-url]
[![SwiftPM Compatible][spm-image]][spm-url]
[![Platform][platform-image]][platform-url]
[![PRs Welcome][PR-image]][PR-url]

#### Animation Type
| Spinner Animation | Pulse Animation | Wave Animation | Wave Animation |
| :--: | :-----: | :--: | :--: |
| ![Alt text](https://github.com/SimformSolutionsPvtLtd/SSCustomPullToRefresh/blob/master/spinnerAnimation.gif?raw=true)  | ![Alt text](https://github.com/SimformSolutionsPvtLtd/SSCustomPullToRefresh/blob/master/pulseAnimation.gif?raw=true) | ![Alt text](https://github.com/SimformSolutionsPvtLtd/SSCustomPullToRefresh/blob/master/waveAnimation.gif?raw=true) | ![Alt text](https://github.com/SimformSolutionsPvtLtd/SSCustomPullToRefresh/blob/master/waveSingleColor.gif?raw=true)

# Requirements
  - iOS 10.0+
  - Xcode 11+

# Installation
#### CocoaPods
 
- You can use CocoaPods to install SSCustomPullToRefresh by adding it to your Podfile:

       use_frameworks!
       pod 'SSCustomPullToRefresh'

- import SSCustomPullToRefresh

#### Manually
-   Download and drop **SSCustomPullToRefresh** folder in your project.
-   Congratulations!

#### Swift Package Manager
-   When using Xcode 11 or later, you can install `SSCustomPullToRefresh` by going to your Project settings > `Swift Packages` and add the repository by providing the GitHub URL. Alternatively, you can go to `File` > `Swift Packages` > `Add Package Dependencies...`
```swift
dependencies: [
    .package(url: "https://github.com/mobile-simformsolutions/SSCustomPullToRefresh.git", from: "1.0.1")
]
```

####  Carthage
-   [Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. You can install Carthage with [Homebrew](http://brew.sh/) using the following command:
```bash
$ brew update
$ brew install carthage
```
To integrate `SSCustomPullToRefresh` into your Xcode project using Carthage, add the following line to your `Cartfile`:

```ogdl
github "mobile-simformsolutions/SSCustomPullToRefresh"
```
Run `carthage` to build and drag the `SSCustomPullToRefresh`(Sources/SSCustomPullToRefresh) into your Xcode project.

# How It Works
- You can use it for any component having a base class as ScrollView like TableView or CollectionView.

#### 1. Spinner Animation
- SpinnerAnimationView takes image and backgroundColor as an input parameter. You can provide it as per your choice.

      spinnerAnnimation = SpinnerAnimationView(image: UIImage(named: "spinner"), backgroundColor: .purple)           
      spinnerAnnimation.delegate = self   
      spinnerAnnimation.parentView = self.tableView    
      spinnerAnnimation.setupRefreshControl()

#### 2. Wave Animation
- SineWaveAnimationView takes Color as an input parameter.

      sineAnnimation = SineWaveAnimationView(color: .purple)           
      sineAnnimation.delegate = self 
      sineAnnimation.parentView = self.tableView
      sineAnnimation.setupRefreshControl()

- Along with this, you can also provide two different colors and a waveHeight value. You can give a waveHeight value between 5.0 to 50.0.

      sineAnnimation = SineWaveAnimationView(frontColor: .orange, backColor: .purple, waveHeight: 10.0)           
 
#### 3. Pulse Animation
- PulseAnimationView takes Color as an input parameter. You can provide center circle color, pulse color and background color of your refresh view. 

      pulseAnnimation = PulseAnimationView(circleColor: .purple, pulseColor: .purple, 
                                                                 pulseViewBackgroundColor: .brown)
      pulseAnnimation.delegate = self   
      pulseAnnimation.parentView = self.tableView
      pulseAnnimation.setupRefreshControl()

#### Delegate
- The `RefreshDelegate` methods can be used to notify start and end refresh.

      extension ViewController: RefreshDelegate {           
        func startRefresh() { }   
        func endRefresh() { }
      }

# Android Library:
* Check our android Library also - [SSPullToRefresh][SSPullToRefresh]
 
# License
- SSCustomPullToRefresh is available under the MIT license. See the LICENSE file for more info.

# Inspired 
-   SSCustomPullToRefresh(SineWaveAnimationView) inspired from [WaveAnimationView](https://github.com/noa4021J/WaveAnimationView)



[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[carthage-image]:https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
[carthage-url]: https://github.com/Carthage/Carthage
[spm-image]:https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg
[spm-url]: https://swift.org/package-manager
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/assets/svg/badges/C-ffb83f-7198e9a1b7ad7f73977b0c9a5c7c3fffbfa25f262510e5681fd8f5a3188216b0.svg
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
[platform-image]:https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat
[platform-url]:http://cocoapods.org/pods/LFAlertController
[cocoa-image]:https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg
[cocoa-url]:https://img.shields.io/cocoapods/v/LFAlertController.svg
[PR-image]:https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square
[PR-url]:http://makeapullrequest.com
[SSPullToRefresh]: <https://github.com/SimformSolutionsPvtLtd/SSPullToRefresh>
