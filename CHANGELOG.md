## Release Notes

### 1.1.1
-  Fix inputToolbar deallocated when presents `CKMessagesViewController` as Model

### 1.1
- CocoaPods officially supported

### 1.0.10
- Reverse the inputToolbar back as inputAccessoryView

### 1.0.9
- Refactor `CKMessageBasicCell`, remove unnecessary view layers
- Enhance some reusable logic, so now the subclass of `CKMessagesBasicCell` could use its own xib file to design the message UI, without bothering the whole message layout
- Optimize `CKMessageBasicCell` constraints batch update logic

### 1.0.8
- Fixed crash when dismiss `CKMessagesViewController`

### 1.0.7
- Move bubble tail width calculation logic from `CKMessageBasicCell` to `CKMessagesViewLayout` to simplify the cell layout logic

### 1.0.6
- Instead of putting inputToolbar as inputAccessoryView in `CKMessagesViewController`, now just a subview.
- When inputToolbar expand higher, move the messages up automatically
- Fixed `CKMessagesView` contentInset.top incorrect

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
