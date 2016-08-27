//: Playground - noun: a place where people can play

import Foundation
import UIKit
import CKMessagesViewController
import PlaygroundSupport


let viewController = UIViewController()
viewController.view.backgroundColor = UIColor.white


PlaygroundPage.current.liveView = viewController

viewController.view.bounds

let stackView = UIStackView(frame: viewController.view.bounds)
stackView.backgroundColor = UIColor.blue.withAlphaComponent(0.25)
stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
stackView.bounds
stackView.axis = .vertical
stackView.spacing = 5
stackView.alignment = .center

viewController.view.addSubview(stackView)

let label = CKInsetsLabel()
label.backgroundColor = UIColor.lightGray
label.text = "Hello World"
label.sizeToFit()
label.bounds


stackView.addSubview(label)
label.textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
label.intrinsicContentSize









