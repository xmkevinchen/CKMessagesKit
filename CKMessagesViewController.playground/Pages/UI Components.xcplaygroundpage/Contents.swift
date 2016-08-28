//: Playground - noun: a place where people can play

import Foundation
import UIKit
import CKMessagesViewController
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
view.backgroundColor = UIColor.white
PlaygroundPage.current.liveView = view

var stringRect = NSString(string: "Incoming message")
    .boundingRect(with: CGSize(width: 600, height: 600),
                  options: [],
                  attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)],
                  context: nil).integral

var size = stringRect.size
size.width += 28
size.height -= stringRect.origin.y


let frame = CGRect(origin: .zero, size: size)


let textView = CKMessageCellTextView(frame: frame)
textView.textContainerInset = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14)
textView.text = "Incoming message"
textView.font = UIFont.preferredFont(forTextStyle: .body)
view.addSubview(textView)

















