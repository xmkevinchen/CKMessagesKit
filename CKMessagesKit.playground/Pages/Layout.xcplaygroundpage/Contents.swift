//: [Previous](@previous)

import CKMessagesKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
view.backgroundColor = UIColor.white

let image = UIImage.bubbleCompat
    .with(mask: UIColor.messageBubbleGreen)
    .flippedHorizontal()
    .stretchable()

let imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
imageView.image = image
view.addSubview(imageView)

let mask = UIView(frame: CGRect(x: 65, y: 60, width: 75, height: 30))
mask.backgroundColor = UIColor.black.withAlphaComponent(0.75)
view.addSubview(mask)

let iv2 = UIImageView(frame: CGRect(x: 50, y: 150, width: 200, height: 100))
iv2.image = UIImage.bubbleCompat
    .with(mask: UIColor.messageBubbleBlue)
    .stretchable()
view.addSubview(iv2)

let mask2 = UIView(frame: CGRect(x: 60, y: 160, width: 175, height: 80))
mask2.backgroundColor = UIColor.black.withAlphaComponent(0.75)
view.addSubview(mask2)

PlaygroundPage.current.liveView = view







//: [Next](@next)
