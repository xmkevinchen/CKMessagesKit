//: Playground - noun: a place where people can play

import Foundation
import CKMessagesViewController
import PlaygroundSupport

struct InsetsLayout<Child: CKViewLayout>: CKViewLayout {
    
    typealias Content = Child.Content
    
    var child: Child
    var insets: UIEdgeInsets
    
    init(child: Child, insets: UIEdgeInsets) {
        self.child = child
        self.insets = insets
    }
    
    mutating func layout(in rect: CGRect) {
        let rect = UIEdgeInsetsInsetRect(rect, insets)
        
        child.layout(in: rect)
    }
    
    var contents: [Content] {
        return child.contents
    }
    
}

extension CKViewLayout {
    
    func insets(_ all: CGFloat) -> InsetsLayout<Self> {
        return InsetsLayout(child: self, insets: UIEdgeInsets(top: all, left: all, bottom: all, right: all))
    }
    
    func insets(_ insets: UIEdgeInsets) -> InsetsLayout<Self> {
        return InsetsLayout(child: self, insets: insets)
    }
    
}


class CKInsetsView: UIView {
    
    var contentView: UIView = UIView()
    
    var insets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        contentView.backgroundColor = UIColor.lightGray
        contentView.contentMode = .scaleAspectFit
        contentView.clipsToBounds = true
        addSubview(contentView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var layout = contentView.insets(insets)
        layout.layout(in: bounds)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

let insetsView = CKInsetsView(frame: CGRect(x:0, y:0, width:100, height:100))

PlaygroundPage.current.liveView = insetsView
let view = UIView(frame: insetsView.bounds)
view.backgroundColor = UIColor.red
insetsView.contentView.addSubview(view)
insetsView.insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)







