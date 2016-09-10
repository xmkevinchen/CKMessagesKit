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

### [Carthage](https://github.com/Carthage/Carthage) (Recommended)

```
github "xmkevinchen/CKMessagesKit"
```

### [CocoaPods](https://cocoapods.org/)

```
platform :ios, '9.0'

target 'Your target' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'CKMessagesKit', :git => 'https://github.com/xmkevinchen/CKMessagesKit.git', :branch => 'master'


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3.0'
      end
  end
end

```



## Getting Started

Checkout the **Sample** project in the repository

Use Carthage to download the dependencies of the Sample project

## Release Note

### 1.0.5
- Refactor `CKMessagesInputToolbar` and its components implementation. Make the implementation more **SOLID** 
    - `CKMessagesInputToolbar` now is more like `UINavigationBar`, focus on laying out items, instead of setting up items, like *Send* button. 
    - Leave the responsibility to concrete subclass of `CKMessagesViewController`. 
    - Get rid of the multiple level delegates propagating up from `CKMessagesToolbarContentView` to `CKMessagesViewController`. 
    - Check out the Sample project to see how to setup `CKMessagesInputToolbar` bar items.

### 1.0.4
- Add `messsagesViewController` property to UIViewController which adopts the `CKMessagePresenting` protocol

### 1.0.3
- Make the `CKMessageViewCell` as default presenting style for message, unless registering presentor of ceitain by using `CKMessagesViewController.register(presentor:for:)` method

### 1.0.2
- Rename `CKMessagesViewDecorating` protocol methods to regular delegate naming style
- Added height attributes to three labels in the `CKMessageDataViewCell`

### 1.0.1
- Fixed some access privilege issue where were supposed to be public or overrided

### 1.0.0
- Basic functionally done `CKMessagesKit`




## TODO
1. Re-design the CKMessageDataViewCell to make more following the SOLID principle
2. Adopt `CKViewLayout` protocol to layout message cell
3. Add more built-in message type cell
4. Solve async content loading problem, especially when presenting multiple styles of collection data in the messages
5. Submit CKMessagesKit to Cocoapods when Swift 3 is supported officially

## Why recreate the wheel
First of all, CKMessagesKit is strongly inspired by [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) and [LayerKit](https://layer.com/).

There're some reasons I created CKMessagesKit

* Pure Swift implementation, written in Swift 3.0
* Easy to support nested collection UI presentation, like using `UICollectionView`, `UITableView` in `UICollectionViewCell` to show such **Data Card** UI design
* JSQMessagesViewController has some design strongly against the SOLID principles and MVC design pattern, misusing the Model and View
* LayerKit heavily integrated with its Layer service


