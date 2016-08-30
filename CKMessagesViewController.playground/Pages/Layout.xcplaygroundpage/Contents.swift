//: [Previous](@previous)

import CKMessagesViewController
import PlaygroundSupport

let text = "Your Apple ID must be associated with a paid Apple Developer Program or Apple Developer Enterprise Program to access certain software downloads."
let font = UIFont.preferredFont(forTextStyle: .body)
var context = NSStringDrawingContext()
let rect = NSString(string: text)
    .boundingRect(with: CGSize(width: 253, height: CGFloat.greatestFiniteMagnitude),
                  options: [.usesLineFragmentOrigin],
                  attributes: [NSFontAttributeName: font],
                  context: context)
context.totalBounds


let textView = UITextView(frame: rect)
textView.text = text
textView.sizeThatFits(CGSize(width: 253, height: CGFloat.greatestFiniteMagnitude))


PlaygroundPage.current.liveView = textView


//: [Next](@next)
