# CKMessagesKit

> A Swiftified, open source, Protocol-Orietated Messages UI Kit for iOS  
    


    
## Design Goals
* [SOLID](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) Principle
* [MVC](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) design pattern
* Closely mimic [iMessages](https://support.apple.com/en-us/HT201287) style and behavior
* Easy customization and extension for clients

    
##  Requirements
* Swift 3.0
* Xcode 8
   
## Installation

### [CocoaPods](https://cocoapods.org/)

```
platform :ios, '9.0'

target 'Messages' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'CKMessagesKit', :git => 'https://github.com/xmkevinchen/CKMessagesKit.git', :branch => 'develop'
  

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3.0'
      end
  end
end

```

### Carthage

```
github "xmkevinchen/CKMessagesKit" "develop"
```

## Getting Started

Checkout the **Sample** project in the repository

## TODO
1. Re-design the CKMessageDataViewCell to make more following the SOLID principle
2. Adopt `CKViewLayout` protocol to layout message cell
3. Add more built-in message type cell
4. Solve async content loading problem, especially when presenting multiple styles of collection data in the messages

## Why recreate the wheel    
First of all, CKMessagesKit is strongly inspired by [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) and [LayerKit](https://layer.com/). 

There're some reasons I created CKMessagesKit

* Pure Swift implementation, written in Swift 3.0
* Easy to support nested collection UI presentation, like using `UICollectionView`, `UITableView` in `UICollectionViewCell` to show such **Data Card** UI design
* JSQMessagesViewController has some design strongly against the MVC design pattern, misusing the Model and View
* LayerKit heavily integrated with its Layer service


