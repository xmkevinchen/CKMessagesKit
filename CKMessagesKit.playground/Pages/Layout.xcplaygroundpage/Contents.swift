//: [Previous](@previous)

import CKMessagesKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
view.backgroundColor = UIColor.white
let image = UIImage.bubbleCompat.stretchable()
view.masked(with: image.stretchable())

PlaygroundPage.current.liveView = view

let name = "kevin chen"

name.capitalized.components(separatedBy: " ").flatMap {
    $0.substring(to: $0.index(after: $0.startIndex))
}.joined()





//: [Next](@next)
