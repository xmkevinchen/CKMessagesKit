//: [Previous](@previous)

import CKMessagesViewController
import PlaygroundSupport

let text = "Your Apple ID must be associated with a paid Apple Developer Program or Apple Developer Enterprise Program to access certain software downloads."
let font = UIFont.preferredFont(forTextStyle: .body)
let rect = NSString(string: text)
    .boundingRect(with: CGSize(width: 198, height: CGFloat.greatestFiniteMagnitude),
                  options: [.usesLineFragmentOrigin, .usesFontLeading],
                  attributes: [NSFontAttributeName: font],
                  context: nil)

let textView = UITextView(frame: rect)
textView.text = text

PlaygroundPage.current.liveView = textView


//: [Next](@next)
