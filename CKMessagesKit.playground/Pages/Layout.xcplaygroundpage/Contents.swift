//: [Previous](@previous)

import CKMessagesKit
import PlaygroundSupport
import QuartzCore

let view = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
view.backgroundColor = UIColor.white
PlaygroundPage.current.liveView = view


//let indicator = CKMessagesIndicatorView(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
//view.addSubview(indicator)
//indicator.startAnimation()




let footer = CKMessagesIndicatorFooterView.nib.instantiate(withOwner: nil, options: nil).last as! CKMessagesIndicatorFooterView

let container = UIView(frame: CGRect(x: 0, y: 200, width: 600, height: 50))
footer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
footer.backgroundColor = UIColor.black.withAlphaComponent(0.25)
container.addSubview(footer)
view.addSubview(container)




//: [Next](@next)
